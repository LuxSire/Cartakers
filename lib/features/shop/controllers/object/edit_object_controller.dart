import 'dart:typed_data';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/data/models/object_model.dart';
import 'package:xm_frontend/data/models/unit_model.dart';
import 'package:xm_frontend/data/models/unit_room_model.dart';
import 'package:xm_frontend/data/models/docs_model.dart';
//import 'package:xm_frontend/data/repositories/authentication/authentication_repository.dart';
import 'package:xm_frontend/data/repositories/object/object_repository.dart';
import 'package:xm_frontend/utils/popups/full_screen_loader.dart';
import 'package:xm_frontend/data/repositories/media/media_repository.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/loaders.dart';
import 'package:intl/intl.dart';
//import '../../../media/models/image_model.dart';

class EditObjectController extends GetxController {
  /// Returns a valid dropdown value for occupancy
  String? getValidOccupancyValue(String? value) {
    final uniqueList = occupancyList.toSet().toList();
    if (value != null && uniqueList.contains(value)) {
      return value;
    }
    return null;
  }

  /// Returns a valid dropdown value for zoning
  String? getValidZoningValue(String? value) {
    final uniqueList = zoningList.toSet().toList();
    if (value != null && uniqueList.contains(value)) {
      return value;
    }
    return null;
  }
  RxList<String> occupancyList = <String>[].obs;
  RxList<String> zoningList = <String>[].obs;
  RxList<String> typeList = <String>[].obs;
  RxList<String> countryList = <String>[].obs;
  /// Set occupancy options
   RxInt selectedCompanyId = 0.obs;
  static EditObjectController get instance => Get.find();

  final loading = false.obs;
  RxString imageURL = ''.obs;
  RxString fileURL = ''.obs;
  final name = TextEditingController();
  final occupancy = TextEditingController();
  final zoning = TextEditingController();
  final city = TextEditingController();
  final description = TextEditingController();
  final owner = TextEditingController();
  final companyId = TextEditingController();
  final currency = TextEditingController();
  final status = TextEditingController();
  final type_ = TextEditingController();
  final price = TextEditingController();
  final street = TextEditingController();
  final objectNumber = TextEditingController();
  final zipCode = TextEditingController();
  final location = TextEditingController();
  final units = TextEditingController();
  final floors = TextEditingController();
  final country = TextEditingController();
  final yieldNet = TextEditingController();
  final yieldGross = TextEditingController();
  final unitdescription=TextEditingController();
  final unitsqm=TextEditingController();
  final noi=TextEditingController();
  final caprate=TextEditingController();

  RxInt sortColumnIndex = 1.obs;
  RxBool sortAscending = true.obs;
  final searchTextController = TextEditingController();
  final _objectRepository = Get.put(ObjectRepository());

  RxBool unitsLoading = true.obs;
  RxBool hasImageChanged = false.obs;
  RxBool hasFileChanged = false.obs;
  RxBool isDataUpdated = false.obs;

  RxList<UnitModel> allObjectUnits = <UnitModel>[].obs;
  RxList<UnitModel> filteredObjectUnits = <UnitModel>[].obs;

  RxList<UnitRoomModel> unitListRooms = <UnitRoomModel>[].obs;
  RxList<DocsModel> objectImages = <DocsModel>[].obs;
  RxList<DocsModel> objectDocs = <DocsModel>[].obs;
  Rx<Uint8List?> memoryBytes = Rx<Uint8List?>(null);

  ObjectModel objectInstance = ObjectModel.empty();

  final formKey = GlobalKey<FormState>();
  final repository = Get.put(ObjectRepository());
  // final List<CategoryModel> selectedCategories = <CategoryModel>[].obs;

  RxList<bool> selectedRows = <bool>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize the controller
    _initLists();
  }

  Future<void> _initLists() async {
    occupancyList.clear();
    zoningList.clear();
    countryList .clear();
    typeList.clear();
    occupancyList.assignAll((await repository.getAllOccupancies()).toSet().toList());
    zoningList.assignAll((await repository.getAllZonings()).toSet().toList());
    typeList.assignAll((await repository.getAllTypes()).toSet().toList());
    countryList.assignAll((await repository.getAllCountries()).toSet().toList());

    debugPrint('Occupancy list: $occupancyList');
    debugPrint('Zoning list: $zoningList');
    debugPrint('Country list: $countryList');
  }

  /// Init Data
  void init(ObjectModel object) {
    name.text = object.name ?? '';
    occupancy.text = object.occupancy ?? 'Full';
    zoning.text = object.zoning ?? 'Agriculture';
    city.text = object.city ?? 'Milan';
    description.text = object.description ?? '';
    owner.text = object.owner?.toString() ?? '';
    status.text = object.status?.toString() ?? '';
    type_.text = object.type_ ?? 'Office';
    price.text = NumberFormat('#,###').format(object.price) ?? '';
    street.text = object.street ?? '';
    zipCode.text = object.zipCode ?? '';
    location.text = object.location ?? '';
    units.text = object.totalUnits?.toString() ?? '';
    floors.text = object.totalFloors?.toString() ?? '';
    yieldGross.text = object.yieldGross?.toString() ?? '';
    yieldNet.text = object.yieldNet?.toString() ?? '';
    imageURL.value = object.imgUrl ?? '';
    currency.text = object.currency ?? 'EUR';
    companyId.text=object.companyId.toString() ?? '';
    country.text = object.country ?? '';
    noi.text=object.noi.toString() ??'';
    caprate.text=object.caprate.toString() ?? '';
    // Fetch object images
    getObjectImages(object);
  } 

  /// Method to reset fields
  void resetFields() {
    name.clear();
    occupancy.clear();
    zoning.clear();
    city.clear();
    description.clear();
    owner.clear();
    currency.clear();
    status.clear();
    type_.clear();
    price.clear();
    street.clear();
    objectNumber.clear();
    zipCode.clear();
    location.clear();
    units.clear();
    floors.clear();
    companyId.clear();
    imageURL.value = '';
    yieldGross.clear();
    yieldNet.clear();
    loading(false);
    noi.clear();
    caprate.clear();
  }


  void updateUnitRoom(UnitModel unit, UnitRoomModel newRoom) 
  {
    unit.pieceId = newRoom.id; // or however you store ID
    unit.pieceName = newRoom.piece; // display name
    // trigger your API call if you want
    if (unit.id != null) {
      repository.updateUnitRoom(unit.id!, int.parse(newRoom.id!)).then(
        (success) {
          if (!success) {
            // optionally show an error or revert
          }
      },
    );
    // tell the table to refresh
    update();
  }
  }

  Future<bool> updateUnitDetails(UnitModel unit) async {
    unit.description = unitdescription.text;
    debugPrint('Updating unit details: ${unit.description}');
    // trigger your API call if you want
    bool success = await repository.updateUnitDetails(unit);
    if (!success) {
      // optionally show an error or revert
      return false;
    }
    // tell the table to refresh
    debugPrint('Updated unit details: ${unit.description}');
    refresh();
    return true;
  } 
  Future<bool> CreateUnit(ObjectModel o) async {
    // trigger your API call if you want
    bool success = await repository.createUnit(o.id!);
    if (!success) {
      // optionally show an error or revert
      return false;
    }
    refresh();
    return true;
  } 
  Future<void> getObjectUnits(ObjectModel object) async {
    try {
      // Show loader while loading categories
      unitsLoading.value = true;

      debugPrint('Object ID: ${object.id}');
      // Fetch customer orders & addresses
      if (object.id != null ) {
        object.units = await ObjectRepository.instance.fetchObjectUnits(
          object.id!,
        );
      }

      objectInstance = object; // save this for later

      allObjectUnits.assignAll(object.units ?? []);

      filteredObjectUnits.assignAll(object.units ?? []);

      // Add all rows as false [Not Selected] & Toggle when required
      selectedRows.assignAll(
        List.generate(
          object.units != null ? object.units!.length : 0,
          (index) => false,
        ),
      );
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      unitsLoading.value = false;
    }
  }
  /// Fetch object image
  /// s from repository
  Future<void> getObjectImages(ObjectModel object) async {
    try {
      if (object.id != null  ) {
        final images = await ObjectRepository.instance.fetchObjectImages(object.id!);
        debugPrint('Fetched images for object ${object.id}: $images');
        
        if (images != null) {
          objectImages.assignAll(images);
        } else {
          objectImages.clear();
        }
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Image Fetch Error', message: e.toString());
      objectImages.clear();
    }
    update();
  }
  /// Fetch object images from repository
  Future<void> getObjectDocs(ObjectModel object) async {
    try {
      if (object.id != null ) {
        final docs = await ObjectRepository.instance.fetchObjectDocs(object.id!);
        debugPrint('Fetched docs for object ${object.id}: $docs');
        
        if (docs != null) {
          objectDocs.assignAll(docs);
        } else {
          objectDocs.clear();
        }
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Image Fetch Error', message: e.toString());
      objectImages.clear();
    }
    update();
  }

  void searchQuery(String query) {
    filteredObjectUnits.assignAll(
      allObjectUnits.where(
        (unit) =>
            unit.description!.toLowerCase().contains(query.toLowerCase()) ||
            unit.unitNumber.toString().contains(query.toLowerCase()),
      ),
    );

    // Notify listeners about the change
    update();
  }

  void sortById(int sortColumnIndex, bool ascending) {
    sortAscending.value = ascending;
    filteredObjectUnits.sort((a, b) {
      if (ascending) {
        return a.unitNumber!.toLowerCase().compareTo(
          b.unitNumber!.toLowerCase(),
        );
      } else {
        return b.unitNumber!.toLowerCase().compareTo(
          a.unitNumber!.toLowerCase(),
        );
      }
    });
    this.sortColumnIndex.value = sortColumnIndex;

    update();
  }

  void pickImage(ObjectModel object) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true, // So we can preview it in memory
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;

      memoryBytes.value = file.bytes;
      hasImageChanged.value = true;

      imageURL.value = file.name;
      _objectRepository.updateObjectDetails(object);
    }
  }

  Future<PickedFileDescriptor?> pickFile() async {
    // Show the file picker dialog and allow the user to select a file
    final result = await FilePicker.platform.pickFiles();

     if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      return PickedFileDescriptor(
        bytes: file.bytes,
        path: file.path ?? '',
        name: file.name,
      );
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

      debugPrint('Uploading file: ${pickedFile.path}');
      isFileUploaded = await _objectRepository.uploadNewDocument(
        objectId,
        directoryName,
        pickedFile,
      );
      debugPrint('Uploaded file: ${pickedFile.path}');

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

  Future<void> submitObject() async {
    if (!formKey.currentState!.validate()) return;

    loading.value = true;
    debugPrint('Submitting object ${name.text.trim()}');
    // AuthenticationRepository.instance.currentUser.agencyId

    var isCreated = false;

    isCreated = await ObjectRepository.instance.createObject(
      
      name.text.trim(),
      street.text.trim(),
      zipCode.text.trim(),
      description.text.trim(),
      city.text.trim(),
      currency.text.trim(),
      double.tryParse(price.text.trim()),
      selectedCompanyId.value ,
      int.parse(units.text.trim()),
      int.parse(floors.text.trim()),
      occupancy.text.trim(),
      zoning.text.trim(),
      country.text.trim(),
      type_.text.trim(),
      imageURL.value,
      int.tryParse(owner.text.trim()),
      int.tryParse(status.text.trim())
    );

    loading.value = false;

    if (isCreated) {
      
      Get.back(result: true); //  Return `true` to indicate object was created

      TLoaders.successSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_info'),
        message: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_data_submitted'),
      );
    } else {
      TLoaders.errorSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_error'),
        message: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_data_failed_to_add'),
      );
    }
  }
  @override
  Future<bool> deleteItem(UnitModel item) async {
    final _objectRepository = ObjectRepository.instance;
    final isDeleted = await _objectRepository.deleteUnit(
      int.parse(item.id.toString()),
    );
    debugPrint('Deleting unit ${item.id} - Success: $isDeleted');
      if (isDeleted) {
          await loadAllUnits(); // <-- Refresh the list after deletion
  }
  return isDeleted;
  }
Future<void> loadAllUnits() async {
  try {
    unitsLoading.value = true;
    // Fetch units for the current objectInstance
    if (objectInstance.id != null) {
      final units = await ObjectRepository.instance.fetchObjectUnits(objectInstance.id!);
      allObjectUnits.assignAll(units ?? []);
      filteredObjectUnits.assignAll(units ?? []);
      // Update selectedRows as well if needed
      selectedRows.assignAll(List.generate(units?.length ?? 0, (index) => false));
    }
  } catch (e) {
    TLoaders.errorSnackBar(title: 'Error', message: e.toString());
  } finally {
    unitsLoading.value = false;
  }
}
  ///
  Future<void> updateObject(ObjectModel object) async {
    try {
      // Start Loading
      TFullScreenLoader.popUpCircular();

      debugPrint('Updating object ${object.name}');
      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }
      /*
      // Form Validation
      if (!formKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }
      */
      debugPrint('Form Validated ${object.name}');

      // Is Data Updated
      bool isObjectUpdatedSuccessfully = false;
      final rawPrice = price.text.replaceAll(RegExp(r'[^\d]'), '').trim();
      // Map Data
      object.companyId=int.tryParse(companyId.text.trim());
      object.name = name.text.trim();
      object.occupancy = occupancy.text.trim();
      object.zoning = zoning.text.trim();
      object.city = city.text.trim();
      object.country=country.text.trim();
      object.currency=currency.text.trim();
      object.description = description.text.trim();
      object.owner = int.tryParse(owner.text.trim());
      object.status = int.tryParse(status.text.trim());
      object.type_ = type_.text.trim();
      object.price = double.tryParse(rawPrice);
      object.street = street.text.trim();
      object.zipCode = zipCode.text.trim();
      object.location = location.text.trim();
      object.imgUrl = imageURL.value;
      object.totalUnits = int.tryParse(units.text.trim()) ?? 1;
      object.totalFloors = int.tryParse(floors.text.trim()) ?? 1;
      object.yieldGross = double.tryParse(yieldGross.text.trim());
      object.yieldNet = double.tryParse(yieldNet.text.trim());
      // Call Repository to Update
      isObjectUpdatedSuccessfully = await repository.updateObject(
        object,
      );

      // Remove Loader
      TFullScreenLoader.stopLoading();

      debugPrint('Updated object updated successfully ${isObjectUpdatedSuccessfully}');

      if (isObjectUpdatedSuccessfully) {
        // update ObjectUnits controller

        isDataUpdated.value = true;

        TLoaders.successSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_info'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_data_updated'),
        );
      } else {
        TLoaders.errorSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_error'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_data_failed'),
        );
      }

      // Update UI Listeners
      update();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_error'),
        message: e.toString(),
      );
    }
  }
}
