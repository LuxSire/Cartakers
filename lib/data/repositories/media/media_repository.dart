import 'package:cartakers/utils/constants/enums.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cartakers/data/repositories/authentication/authentication_repository.dart';
import 'package:cartakers/data/api/services/object_service.dart';
import 'package:cartakers/data/api/services/user_service.dart';
import '../../../features/media/models/image_model.dart';



 class PickedFileDescriptor {
  final Uint8List? bytes; // for web
  final String path;     // for mobile/desktop
  final String name;

  PickedFileDescriptor({this.bytes, required this.path, required this.name});
}

class MediaRepository extends GetxController {
  static MediaRepository get instance => Get.find();


  final _objectService = ObjectService();
  final _userService = UserService();

  // Firebase Storage instance

  /// Upload any Image using File
  Future<void> uploadImageFileInStorage({
    required html.File file,
    required String path,
    required String imageName,
  }) async {
    //  return ImageModel.fromFirebaseMetadata('metadata', path, imageName, 'downloadURL');
  }

  /// Upload Image data in Firestore
  Future<String> uploadImageFileInDatabase(ImageModel image) async {
    return 'imageId';
  }

  // Fetch images from Firestore based on media category and load count
  Future<List<ImageModel>> fetchImagesFromDatabase(
    MediaCategory mediaCategory,
    int loadCount,
  ) async {
    return [];
  }

  // Load more images from Firestore based on media category, load count, and last fetched date
  Future<List<ImageModel>> loadMoreImagesFromDatabase(
    MediaCategory mediaCategory,
    int loadCount,
    DateTime lastFetchedDate,
  ) async {
    return [];
  }

  // Fetch all images from Firebase Storage
  Future<List<ImageModel>> fetchAllImages() async {
    return [];
  }

  // Delete file from Firebase Storage and corresponding document from Firestore
  Future<void> deleteFileFromStorage(ImageModel image) async {
    return;
  }

  /// docType: 'user' or 'object'
  Future<bool> uploadNewDocument(
    int id,
    String directoryName,
    PickedFileDescriptor pickedFile,
    {String docType='user'} // 'user' or 'object'
  ) async {
    try {
      Map<String, dynamic> documentResponse;
      if (docType == 'user') {
        documentResponse = await _userService.uploadAzureDocument(
          file: pickedFile,
          userId: id,
          containerName: "docs",
          directoryName: directoryName,
        );
      } else if (docType == 'object') {
        documentResponse = await _objectService.uploadAzureDocument(
          file: pickedFile,
          objectId: id,
          containerName: "docs",
          directoryName: directoryName,
        );
      } else {
        debugPrint('Unknown docType: $docType');
        return false;
      }

      if (documentResponse['success'] == false) {
        debugPrint("Failed to upload document: "+documentResponse['message'].toString());
        return false;
      }
      // Optionally handle response data here
      return true;
    } catch (e) {
      debugPrint('Error uploading document: $e');
      return false;
    }
  }


  Future<bool> deleteDocument(
    String fileName,
    String containerName,
    String directoryName,
  ) async {
    try {
      final documentResponse = await _objectService.deleteDocumentFromAzure(
        fileName: fileName,
        containerName: containerName,
        directoryName: directoryName,
      );

      if (documentResponse['success'] == false) {
        debugPrint("Failed to delete document: ${documentResponse['message']}");
        return false;
      } 

      return true;
    } catch (e) {
      debugPrint('Error deleting document: $e');
      return false;
    }
  }

  Future<bool> updateFileName(String documentId, String newFileName) async {
    try {
      final documentResponse = await _objectService.updateFileName(
        documentId,
        newFileName,
      );

      if (documentResponse['success'] == false) {
        debugPrint(
          "Failed to update file name: ${documentResponse['message']}",
        );
        return false;
      }

      return true;
    } catch (e) {
      debugPrint('Error update file name: $e');
      return false;
    }
  }

}
