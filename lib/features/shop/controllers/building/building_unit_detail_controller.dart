import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:xm_frontend/data/models/contract_model.dart';
import 'package:xm_frontend/data/models/unit_model.dart';
import 'package:xm_frontend/data/repositories/building/building_repository.dart';
import 'package:xm_frontend/features/shop/controllers/contract/contract_controller.dart';

import '../../../../data/repositories/user/user_repository.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../personalization/models/user_model.dart';

class BuildingUnitDetailController extends GetxController {
  static BuildingUnitDetailController get instance => Get.find();

  RxBool loading = true.obs;
  RxBool contractsLoading = true.obs;

  RxBool ordersLoading = true.obs;
  RxBool addressesLoading = true.obs;
  RxInt sortColumnIndex = 1.obs;
  RxBool sortAscending = true.obs;
  RxList<bool> selectedRows = <bool>[].obs;
  RxList<UserModel> allTenants = <UserModel>[].obs;

  RxBool isDataUpdated = false.obs;

  Rx<UnitModel> unit = UnitModel.empty().obs;
  //final addressRepository = Get.put(AddressRepository());
  final searchTextController = TextEditingController();
  RxList<ContractModel> allBuildingUnitContracts = <ContractModel>[].obs;
  RxList<ContractModel> filteredBuildingUnitContracts = <ContractModel>[].obs;

  /// -- Load customer orders
  Future<void> getTenantsOfCurrentUnit() async {
    try {
      // Show loader while loading categories
      loading.value = true;
      // Fetch tenants

      //   debugPrint('getTenantsOfCurrentUnit');

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

      final tenants = await UserRepository.instance.fetchTenantsByContractId(
        unit.value.currentContractId!,
      );

      allTenants.value = tenants;

      // refresh the filtered list
      allTenants.refresh();

      update();
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      loading.value = false;
    }
  }

  Future<void> getUnitContracts(UnitModel unit) async {
    try {
      // Show loader while loading categories
      contractsLoading.value = true;

      if (unit.id != null && unit.id!.isNotEmpty) {
        unit.contracts = await BuildingRepository.instance
            .fetchBuildingUnitContracts(unit.id!);
      }

      allBuildingUnitContracts.assignAll(unit.contracts ?? []);

      filteredBuildingUnitContracts.assignAll(unit.contracts ?? []);

      // now for eact contract get the tenants data

      unit.contracts?.forEach((contract) async {
        if (contract.id != null) {
          try {
            var tenantsRetrived = await UserRepository.instance
                .fetchTenantsByContractId(int.parse(contract.id!));

            //   debugPrint('Tenants in contract ID : ${contract.id}');

            //    debugPrint('Tenants in here : ${tenantsRetrived.length}');

            contract.tenants = tenantsRetrived;
          } catch (e) {
            debugPrint('Error fetching tenants: $e');
          }
        }
      });

      // Add all rows as false [Not Selected] & Toggle when required
      selectedRows.assignAll(
        List.generate(
          unit.contracts != null ? unit.contracts!.length : 0,
          (index) => false,
        ),
      );
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      contractsLoading.value = false;
    }
  }

  void searchQuery(String query) {
    filteredBuildingUnitContracts.assignAll(
      allBuildingUnitContracts.where(
        (contract) =>
            contract.id!.toLowerCase().contains(query.toLowerCase()) ||
            contract.contractCode.toString().contains(query.toLowerCase()),
      ),
    );

    // Notify listeners about the change
    update();
  }

  void sortById(int sortColumnIndex, bool ascending) {
    sortAscending.value = ascending;
    filteredBuildingUnitContracts.sort((a, b) {
      if (ascending) {
        return a.contractCode!.toLowerCase().compareTo(
          b.contractCode!.toLowerCase(),
        );
      } else {
        return b.contractCode!.toLowerCase().compareTo(
          a.contractCode!.toLowerCase(),
        );
      }
    });
    this.sortColumnIndex.value = sortColumnIndex;

    update();
  }
}
