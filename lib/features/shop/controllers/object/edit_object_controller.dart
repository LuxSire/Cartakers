import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/data/models/object_model.dart';
import 'package:xm_frontend/data/models/unit_model.dart';
import 'package:xm_frontend/data/models/unit_room_model.dart';
import 'package:xm_frontend/data/repositories/authentication/authentication_repository.dart';
import 'package:xm_frontend/data/repositories/object/object_repository.dart';
import 'package:xm_frontend/utils/popups/full_screen_loader.dart';

import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../media/models/image_model.dart';

class EditObjectController extends GetxController {
  static EditObjectController get instance => Get.find();

  final loading = false.obs;
  RxString imageURL = ''.obs;
  final name = TextEditingController();
  final street = TextEditingController();
  final objectNumber = TextEditingController();
  final zipCode = TextEditingController();
  final location = TextEditingController();
  final units = TextEditingController();
  final floors = TextEditingController();

  RxInt sortColumnIndex = 1.obs;
  RxBool sortAscending = true.obs;
  final searchTextController = TextEditingController();

  RxBool unitsLoading = true.obs;
  RxBool hasImageChanged = false.obs;
  RxBool isDataUpdated = false.obs;

  RxList<UnitModel> allObjectUnits = <UnitModel>[].obs;
  RxList<UnitModel> filteredObjectUnits = <UnitModel>[].obs;

  RxList<UnitRoomModel> unitListRooms = <UnitRoomModel>[].obs;

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

  }

  /// Init Data
  void init(ObjectModel object) {
    name.text = object.name!;
    street.text = object.street!;
    objectNumber.text = object.objectNumber!;
    zipCode.text = object.zipCode!;
    location.text = object.location!;
    units.text = object.totalUnits!.toString();
    floors.text = object.totalFloors!.toString();
    imageURL.value = object.imgUrl!;
  }

  /// Method to reset fields
  void resetFields() {
    name.clear();
    street.clear();
    objectNumber.clear();
    zipCode.clear();
    location.clear();
    units.clear();
    floors.clear();
    imageURL.value = '';

    loading(false);
  }

  void updateUnitRoom(UnitModel unit, UnitRoomModel newRoom) {
    unit.pieceId = newRoom.id; // or however you store ID
    unit.pieceName = newRoom.piece; // display name
    // trigger your API call if you want
    repository.updateUnitRoom(int.parse(unit.id!), int.parse(newRoom.id!)).then(
      (success) {
        if (!success) {
          // optionally show an error or revert
        }
      },
    );
    // tell the table to refresh
    update();
  }

  Future<void> getObjectUnits(ObjectModel object) async {
    try {
      // Show loader while loading categories
      unitsLoading.value = true;

      debugPrint('Object ID: ${object.id}');
      // Fetch customer orders & addresses
      if (object.id != null && object.id!.isNotEmpty) {
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

  void searchQuery(String query) {
    filteredObjectUnits.assignAll(
      allObjectUnits.where(
        (unit) =>
            unit.id!.toLowerCase().contains(query.toLowerCase()) ||
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

  void pickImage() async {
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
    }
  }

  Future<void> submitObject() async {
    if (!formKey.currentState!.validate()) return;

    loading.value = true;

    // AuthenticationRepository.instance.currentUser.agencyId

    var isCreated = false;

    isCreated = await ObjectRepository.instance.createObject(
      name.text.trim(),
      street.text.trim(),
      objectNumber.text.trim(),
      zipCode.text.trim(),
      location.text.trim(),
      int.parse(units.text.trim()),
      int.parse(floors.text.trim()),
    );

    loading.value = false;

    if (isCreated) {
      Get.back(result: true); //  Return `true` to indicate tenant was created

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

  ///
  Future<void> updateObject(ObjectModel object) async {
    try {
      // Start Loading
      TFullScreenLoader.popUpCircular();

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!formKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Is Data Updated
      bool isObjectUpdatedSuccessfully = false;

      // Map Data
      object.name = name.text.trim();
      object.street = street.text.trim();
      object.objectNumber = objectNumber.text.trim();
      object.zipCode = zipCode.text.trim();
      object.location = location.text.trim();
      object.imgUrl = imageURL.value;

      // Call Repository to Update
      isObjectUpdatedSuccessfully = await repository.updateObjectDetails(
        object,
      );

      // Remove Loader
      TFullScreenLoader.stopLoading();

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
