import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:path/path.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/data/models/contract_model.dart';
import 'package:xm_frontend/features/shop/controllers/building/building_unit_detail_controller.dart';
import 'package:xm_frontend/features/shop/controllers/building/edit_building_controller.dart';
import 'package:xm_frontend/features/shop/controllers/contract/contract_controller.dart';
import 'package:xm_frontend/features/shop/screens/contract/dialogs/edit_contract.dart';
import 'package:xm_frontend/routes/routes.dart';
import 'package:xm_frontend/utils/constants/sizes.dart';
import 'package:xm_frontend/utils/helpers/helper_functions.dart';
import 'package:xm_frontend/utils/popups/dialogs.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/colors.dart';

class BuildingUnitContractsRows extends DataTableSource {
  final controller = BuildingUnitDetailController.instance;

  @override
  DataRow? getRow(int index) {
    final contract = controller.filteredBuildingUnitContracts[index];
    return DataRow2(
      specificRowHeight: 80,
      onTap: () {
        Get.toNamed(Routes.contractDetails, arguments: contract)?.then((
          result,
        ) async {
          if (result == true) {
            final controllerContract = ContractController.instance;

            contract.contractCode =
                controllerContract.contractModel.value.contractCode;
            contract.startDate =
                controllerContract.contractModel.value.startDate;
            contract.endDate = controllerContract.contractModel.value.endDate;
            contract.tenantCount =
                controllerContract.contractModel.value.tenantCount;
            contract.tenantNames =
                controllerContract.contractModel.value.tenantNames;
            contract.statusId = controllerContract.contractModel.value.statusId;
            contract.tenants = controllerContract.contractModel.value.tenants;

            final controllerUnitDetail = BuildingUnitDetailController.instance;

            controllerUnitDetail.unit.value.tenantCount =
                controllerContract.contractModel.value.tenantCount;
            controllerUnitDetail.unit.value.tenantNames =
                controllerContract.contractModel.value.tenantNames;

            if (controllerContract.contractModel.value.statusId == 2 ||
                controllerUnitDetail.unit.value.statusId == 3) {
              // terminated or peding
              controllerUnitDetail.unit.value.statusId = 1; // vacant
              controllerUnitDetail
                  .unit
                  .value
                  .statusText = THelperFunctions.getUnitStatusText(1);
              controllerUnitDetail.unit.value.contractCode = '-';
              controllerUnitDetail.unit.value.currentContractId = 0;
              controllerUnitDetail.unit.value.tenantCount = 0;
              controllerUnitDetail.unit.value.tenantNames = '';
              controllerUnitDetail.unit.value.updatedAt = DateTime.now();
            } else {
              controllerUnitDetail.unit.value.statusId = 2;
              controllerUnitDetail
                  .unit
                  .value
                  .statusText = THelperFunctions.getUnitStatusText(2);
              controllerUnitDetail.unit.value.contractCode =
                  controllerContract.contractModel.value.contractCode;
              controllerUnitDetail.unit.value.currentContractId = int.tryParse(
                controllerContract.contractModel.value.id ?? '',
              );
              controllerUnitDetail.unit.value.updatedAt = DateTime.now();
              controllerUnitDetail.unit.value.tenantCount =
                  controllerContract.contractModel.value.tenantCount;
              controllerUnitDetail.unit.value.tenantNames =
                  controllerContract.contractModel.value.tenantNames;
            }
            await controller.getTenantsOfCurrentUnit();

            controllerUnitDetail.unit.refresh();

            controller.isDataUpdated.value = true;

            notifyListeners();
          }
        });
      },

      selected: controller.selectedRows[index],
      cells: [
        DataCell(
          Text(
            contract.contractCode!,
            style: Theme.of(
              Get.context!,
            ).textTheme.bodyLarge!.apply(color: TColors.primary),
          ),
        ),
        DataCell(Text(contract.formattedStartDate)),
        DataCell(
          Text(
            contract.formattedEndDate != ''
                ? contract.formattedEndDate
                : contract.statusId ==
                    1 // active
                ? AppLocalization.of(
                  Get.context!,
                ).translate('general_msgs.msg_ongoing')
                : '-',
          ),
        ),
        DataCell(Text('${contract.tenantNames} ')),
        DataCell(
          TRoundedContainer(
            radius: TSizes.cardRadiusSm,
            padding: const EdgeInsets.symmetric(
              vertical: TSizes.sm,
              horizontal: TSizes.md,
            ),
            backgroundColor: THelperFunctions.getUnitContractStatusColor(
              contract.statusId!,
            ).withOpacity(0.1),
            child: Text(
              THelperFunctions.getUnitContractStatusText(contract.statusId!),
              style: TextStyle(
                color: THelperFunctions.getUnitStatusColor(contract.statusId!),
              ),
            ),
          ),
        ),
        DataCell(
          PopupMenuButton<String>(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            offset: const Offset(0, 40),
            color: Colors.white, // match your card color
            onSelected: (value) async {
              if (value == 'edit') {
                final updatedContract = await showDialog<ContractModel>(
                  context: Get.context!,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return EditContractDialog(
                      contractId: int.parse(contract.id!),
                    );
                  },
                );

                if (updatedContract != null) {
                  //  Replace the updated contract in the list
                  final index = controller.filteredBuildingUnitContracts
                      .indexWhere((c) => c.id == updatedContract.id);
                  final previousContract =
                      controller.filteredBuildingUnitContracts[index];

                  controller.isDataUpdated.value = true;

                  if (index != -1) {
                    // found
                    controller.filteredBuildingUnitContracts[index] =
                        updatedContract;

                    debugPrint(
                      'Updated Contract: ${updatedContract.contractCode} - ${updatedContract.tenantNames}',
                    );

                    if (updatedContract.statusId == 2) {
                      // first check if value before was active

                      debugPrint(
                        'Previous Contract: ${previousContract.contractCode} - ${previousContract.statusId}',
                      );

                      if (previousContract.statusId == 1) {
                        // 2 = Terminated
                        controller.unit.update((u) {
                          u?.statusId = 1; // vacant
                          u?.statusText = THelperFunctions.getUnitStatusText(1);
                          u?.contractCode = '-';
                          u?.currentContractId = 0;
                          u?.tenantCount = 0;
                          u?.tenantNames = '';
                          u?.updatedAt = DateTime.now();
                        });

                        controller.allTenants
                            .clear(); // Clear visible tenants list
                      }
                    } else if (updatedContract.statusId == 1) {
                      // 1 = Active
                      controller.unit.update((u) {
                        u?.statusId = 2; // occupied
                        u?.statusText = THelperFunctions.getUnitStatusText(2);
                        u?.contractCode = updatedContract.contractCode;
                        u?.tenantCount = updatedContract.tenantCount;
                        u?.updatedAt = DateTime.now();

                        u?.tenantNames = updatedContract.tenantNames;
                        u?.currentContractId = int.tryParse(
                          updatedContract.id ?? '',
                        );
                      });
                      await controller.getTenantsOfCurrentUnit();
                    }
                    contract.tenantNames = updatedContract.tenantNames;
                    // notifyListeners(); //  Refresh DataTable
                  }
                }
              } else if (value == 'terminate') {
                final controllerContract = Get.put(ContractController());

                final currentContract =
                    controller.filteredBuildingUnitContracts[index];

                //debugPrint(updatedContract.toJson().toString());

                var updatedContract = currentContract;
                updatedContract.statusId = 2; // 2 = Terminated
                updatedContract.endDate = DateTime.now(); // Set end date to now

                final updatedResult = await controllerContract
                    .submitContractTerminate(updatedContract);
                if (updatedResult) {
                  controller.isDataUpdated.value = true;

                  //  Replace the updated contract in the list
                  final index = controller.filteredBuildingUnitContracts
                      .indexWhere((c) => c.id == updatedContract.id);

                  if (index != -1) {
                    // found
                    controller.filteredBuildingUnitContracts[index] =
                        updatedContract;

                    // 2 = Terminated
                    controller.unit.update((u) {
                      u?.statusId = 1; // vacant
                      u?.statusText = THelperFunctions.getUnitStatusText(1);
                      u?.contractCode = '-';
                      u?.currentContractId = 0;
                      u?.tenantCount = 0;
                      u?.tenantNames = '';
                      u?.updatedAt = DateTime.now();
                    });

                    controller.allTenants.clear(); // Clear visible tenants list
                  }
                }
              } else if (value == 'delete') {
                final confirmed = await showDeleteConfirmation(
                  contract.contractCode!,
                );

                if (confirmed) {
                  final controllerContract = Get.put(ContractController());

                  final deleted = await controllerContract.deleteItem(contract);
                  if (deleted) {
                    controller.isDataUpdated.value = true;

                    // Remove the contract from the list
                    controller.filteredBuildingUnitContracts.removeAt(index);
                    notifyListeners();
                  }
                }
              }
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        const Icon(Icons.edit, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalization.of(
                            Get.context!,
                          ).translate('general_msgs.msg_edit'),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  if (contract.statusId == 1)
                    PopupMenuItem(
                      value: 'terminate',
                      child: Row(
                        children: [
                          const Icon(
                            Icons.cancel_outlined,
                            color: Colors.orange,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            AppLocalization.of(
                              Get.context!,
                            ).translate('general_msgs.msg_terminate_contract'),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  if (contract.statusId != 1)
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            AppLocalization.of(
                              Get.context!,
                            ).translate('general_msgs.msg_delete'),
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                ],
            icon: const Icon(Icons.more_vert),
          ),
        ),
      ],
    );
  }

  Future<bool> showDeleteConfirmation(String contractCode) async {
    final context = Get.context!;
    // showDialog returns a Future<T?>, so we cast to bool and default to false
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // force a choice
      builder:
          (ctx) => AlertDialog(
            title: Text(
              AppLocalization.of(
                Get.context!,
              ).translate('general_msgs.msg_delete_item'),
            ),
            content: Text(
              '${AppLocalization.of(Get.context!).translate('general_msgs.msg_are_you_sure_delete_item')} ${contractCode.isNotEmpty ? '"$contractCode"' : ''}',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text(
                  AppLocalization.of(
                    Get.context!,
                  ).translate('general_msgs.msg_cancel'),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  //  primary: TColors.error, // or your brand’s danger color
                ),
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Text(
                  AppLocalization.of(
                    Get.context!,
                  ).translate('general_msgs.msg_yes'),
                ),
              ),
            ],
          ),
    );
    return confirmed == true;
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.filteredBuildingUnitContracts.length;

  @override
  int get selectedRowCount =>
      controller.selectedRows.where((selected) => selected).length;
}
