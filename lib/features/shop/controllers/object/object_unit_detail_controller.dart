import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:xm_frontend/data/models/permission_model.dart';
import 'package:xm_frontend/data/models/unit_model.dart';
import 'package:xm_frontend/data/repositories/object/object_repository.dart';
import 'package:xm_frontend/features/shop/controllers/contract/permission_controller.dart';

import '../../../../data/repositories/user/user_repository.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../personalization/models/user_model.dart';

class ObjectUnitDetailController extends GetxController {
  static ObjectUnitDetailController get instance => Get.find();

  RxBool loading = true.obs;
  RxBool contractsLoading = true.obs;

  RxBool ordersLoading = true.obs;
  RxBool addressesLoading = true.obs;
  RxInt sortColumnIndex = 1.obs;
  RxBool sortAscending = true.obs;
  RxList<bool> selectedRows = <bool>[].obs;
  RxList<UserModel> allUsers = <UserModel>[].obs;

  RxBool isDataUpdated = false.obs;

  Rx<UnitModel> unit = UnitModel.empty().obs;
  //final addressRepository = Get.put(AddressRepository());
  final searchTextController = TextEditingController();
  RxList<PermissionModel> allObjectUnitContracts = <PermissionModel>[].obs;
  RxList<PermissionModel> filteredObjectUnitContracts = <PermissionModel>[].obs;

  @override
  Future<bool> deleteItem(UnitModel item) async {
    final _objectRepository = ObjectRepository.instance;
    final isDeleted = await _objectRepository.deleteUnit(
      int.parse(item.id.toString()),
    );
      if (isDeleted) {
    await loadAllUnits(); // <-- Refresh the list after deletion
  }
  return isDeleted;
  }
Future<void> loadAllUnits() async {
  // fetch units from repository and assign to your RxList
  //final units = await ObjectRepository.instance.fetchUnits();
  // assign to your observable list
  // e.g., allUnits.assignAll(units);
}
  /// -- Load customer orders
  Future<void> getUsersOfCurrentUnit() async {
    try {
      // Show loader while loading categories
      loading.value = true;
      // Fetch users

      //   debugPrint('getUsersOfCurrentUnit');

      // debugPrint('Current contract ID : ${unit.value.currentContractId}');

      // show json of unit
      debugPrint('Unit JSON : ${unit.value.toJson()}');

      if (unit.value.currentContractId == null) {
        //    TLoaders.errorSnackBar(
        //    title: 'Oh Snap!',
        //    message: 'No contract ID found for this unit.',
        // );
        return;
      }
      //   Fetch all tenants by contract ID

      final users = await UserRepository.instance.fetchUsersByContractId(
        unit.value.currentContractId!,
      );

      allUsers.value = users;

      // refresh the filtered list
      allUsers.refresh();

      update();
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      loading.value = false;
    }
  }

  void searchQuery(String query) {
    filteredObjectUnitContracts.assignAll(
      allObjectUnitContracts.where(
        (contract) =>
            contract.id!.toLowerCase().contains(query.toLowerCase()) ||
            contract.permissionId.toString().contains(query.toLowerCase()),
      ),
    );

    // Notify listeners about the change
    update();
  }

  void sortById(int sortColumnIndex, bool ascending) {
    sortAscending.value = ascending;
    filteredObjectUnitContracts.sort((a, b) {
      if (ascending) {
        return a.permissionId!.compareTo(
          b.permissionId!,
        );
      } else {
        return b.permissionId!.compareTo(
          a.permissionId!,
        );
      }
    });
    this.sortColumnIndex.value = sortColumnIndex;

    update();
  }
}
