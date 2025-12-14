import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cartakers/app/localization/app_localization.dart';
import 'package:cartakers/data/models/amenity_zone_model.dart';
import 'package:cartakers/data/models/docs_model.dart';
import 'package:cartakers/data/models/unit_model.dart';
import 'package:cartakers/data/repositories/object/object_repository.dart';
import 'package:cartakers/data/repositories/media/media_repository.dart';
import 'package:cartakers/utils/helpers/network_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cartakers/data/models/amenity_zone_model.dart';
import 'package:cartakers/data/models/unit_model.dart';
import 'package:cartakers/data/repositories/object/object_repository.dart';
import 'package:cartakers/data/repositories/user/user_repository.dart';
import 'package:cartakers/utils/popups/loaders.dart';
import 'package:cartakers/utils/popups/full_screen_loader.dart';

class DocumentController extends GetxController {
  static DocumentController get instance => Get.find();
  final MediaRepository _mediaRepository = MediaRepository.instance;
  
  final int? userId;
  final int? objectId;
  final formKey = GlobalKey<FormState>();
  final searchController = TextEditingController();
  final renameDocumentController = TextEditingController();

  final loading = false.obs;
  final selectedZoneId = RxnInt();
  final docs = <DocsModel>[].obs;
  final allDocs = <DocsModel>[].obs;
  final filteredDocs = <DocsModel>[].obs;

    DocumentController({this.userId, this.objectId});

  @override
  void onInit() {
    super.onInit();
    if (!Get.isRegistered<MediaRepository>()) {
     Get.put(MediaRepository());
}
    loadData();
  }

  Future<void> loadData() async {
    try {
      loading.value = true;
      docs.clear();

      filteredDocs.clear();

      
      if (userId != null) {
        docs.assignAll(await UserRepository.instance.fetchUserDocsByUserId(userId!));
      } else if (objectId != null) {
        docs.assignAll(await ObjectRepository.instance.fetchObjectDocs(objectId!));
      }

      debugPrint('Docs: ${docs.length}');

      filteredDocs.assignAll(docs);
    } finally {
      loading.value = false;
    }
  }

  void openDocument(String fileUrl) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/${fileUrl.split('/').last}';

      File file = File(filePath);

      // Download the file if it doesn't already exist
      if (!file.existsSync()) {
        debugPrint("Downloading file...");
        final response = await http.get(Uri.parse(fileUrl));
        await file.writeAsBytes(response.bodyBytes);
      }

      debugPrint("Opening downloaded file: $filePath");

      // Open the file with the associated app
      final result = await OpenFile.open(filePath);
      debugPrint("OpenFile result: ${result.type}, Message: ${result.message}");
    } catch (e) {
      debugPrint("Error opening document: $e");
    }
  }

    Future<File?> deprecated_pickFile() async {
    // Show the file picker dialog and allow the user to select a file
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) {
      return File(result.files.single.path!); // Return the file
    } else {
      return null; // No file selected
    }
  }
 
  Future<PickedFileDescriptor?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(withData: true);
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      return PickedFileDescriptor(
        bytes: file.bytes,
        path: file.path ?? '',
        name: file.name,
      );
    }
  return null;
}
  Future<bool> deleteDocumentFromAzure(
    String fileName,
    String containerName,
    String directoryName,
  ) async {
    try {
      if (fileName == '') {
        debugPrint('No file name found.');
        return false;
      }

      // Start Loading
      loading.value = true;

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        loading.value = false;
        return false;
      }
      bool isFileDeleted = false;

      isFileDeleted = await _mediaRepository.deleteDocument(
        fileName,
        containerName,
        directoryName,
      );

      // Remove Loader
      loading.value = false;

      if (isFileDeleted) {
        TLoaders.successSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_info'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_document_deleted'),
        );
      } else {
        TLoaders.errorSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_error'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_document_delete_failed'),
        );
        return false;
      }

      // Update UI Listeners
      update();
      return true;
    } catch (e) {
      debugPrint('Error from catch uploadDocumentToAzure: $e');
      loading.value = false;
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_error'),
        message: e.toString(),
      );
      return false;
    }
  }

  Future<bool> uploadDocumentToAzure(PickedFileDescriptor pickedFile, int objectId) async {
    try {
      if (pickedFile == null) {
        debugPrint('No file selected.');
        return false;
      }

      final directoryName =
          "objects/$objectId"; // Set the directory for storage

      // Start Loading
      loading.value = true;

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        loading.value = false;
        return false;
      }
      bool isFileUploaded = false;

      isFileUploaded = await _mediaRepository.uploadNewDocument(
        objectId,
        directoryName,
        pickedFile 
      );

      // Remove Loader
      loading.value = false;

      if (isFileUploaded) {
        TLoaders.successSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_info'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_new_document_uploaded_successfully'),
        );
      } else {
        TLoaders.errorSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_error'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_document_failed'),
        );
        return false;
      }

      // Update UI Listeners
      update();
      return true;
    } catch (e) {
      debugPrint('Error from catch uploadDocumentToAzure: $e');
      loading.value = false;
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_error'),
        message: e.toString(),
      );
      return false;
    }
  }
  Future<bool> uploadUserDocumentToAzure(PickedFileDescriptor pickedFile, int userId) async {
    try {
      if (pickedFile == null) {
        debugPrint('No file selected.');
        return false;
      }

      final directoryName =
          "users/$userId"; // Set the directory for storage

      // Start Loading
      loading.value = true;

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        loading.value = false;
        return false;
      }
      bool isFileUploaded = false;

      debugPrint('Uploading file: ${pickedFile.path} to user directory: $directoryName');
      debugPrint('User ID: $userId');

      isFileUploaded = await _mediaRepository.uploadNewDocument(
        userId,
        directoryName,
        pickedFile,
      );

      debugPrint('File upload status: $isFileUploaded');

      // Remove Loader
      loading.value = false;

      if (isFileUploaded) {
        TLoaders.successSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_info'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_new_document_uploaded_successfully'),
        );
      } else {
        TLoaders.errorSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_error'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_document_failed'),
        );
        return false;
      }

      // Update UI Listeners
      update();
      return true;
    } catch (e) {
      debugPrint('Error from catch uploadDocumentToAzure: $e');
      loading.value = false;
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_error'),
        message: e.toString(),
      );
      return false;
    }
  }

  Future<bool> renameFile(String documentId, String newFileName) async {
    try {
      // Start Loading
      loading.value = true;

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        loading.value = false;
        return false;
      }
      bool isRenameFileUpdatedSuccessfuly = false;

      isRenameFileUpdatedSuccessfuly = await _mediaRepository.updateFileName(
        documentId,
        newFileName,
      );

      // Remove Loader
      loading.value = false;

      debugPrint(
        'isRenameFileUpdatedSuccessfuly: $isRenameFileUpdatedSuccessfuly',
      );

      if (isRenameFileUpdatedSuccessfuly) {
        Get.back(result: newFileName);
        TLoaders.successSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_info'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_rename_file_success'),
        );
      } else {
        TLoaders.errorSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_error'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_rename_file_failed'),
        );
        return false;
      }

      // Update UI Listeners
      update();
      return true;
    } catch (e) {
      debugPrint('Error from catch renameFile: $e');
      loading.value = false;
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_error'),
        message: e.toString(),
      );
      return false;
    }
  }



  void filterDocs(String query) {
    if (query.isEmpty) {
      filteredDocs.assignAll(docs);
    } else {
      filteredDocs.assignAll(
        docs.where(
          (doc) =>
              doc.fileName?.toLowerCase().contains(query.toLowerCase()) ??
              false,
        ),
      );
    }
  }
}
