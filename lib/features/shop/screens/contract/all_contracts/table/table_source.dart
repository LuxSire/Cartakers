import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/common/widgets/icons/table_action_icon_buttons.dart';
import 'package:xm_frontend/data/models/contract_model.dart';
import 'package:xm_frontend/features/shop/controllers/object/object_unit_detail_controller.dart';
import 'package:xm_frontend/features/shop/controllers/object/edit_object_controller.dart';
import 'package:xm_frontend/features/shop/controllers/contract/contract_controller.dart';
import 'package:xm_frontend/features/shop/screens/contract/dialogs/edit_contract.dart';
import 'package:xm_frontend/routes/routes.dart';
import 'package:xm_frontend/utils/constants/sizes.dart';
import 'package:xm_frontend/utils/helpers/helper_functions.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/colors.dart';

class ContractsRows extends DataTableSource {
  final controller = ContractController.instance;

  @override
  DataRow? getRow(int index) {
    if (index >= controller.filteredItems.length)
      return null; // prevent overflow

    final contract = controller.filteredItems[index];
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
            contract.userCount =
                controllerContract.contractModel.value.userCount;
            contract.userNames =
                controllerContract.contractModel.value.userNames;
            contract.statusId = controllerContract.contractModel.value.statusId;
            contract.users = controllerContract.contractModel.value.users;

            notifyListeners();
          }
        });
      },

      selected: controller.selectedRows[index],
      cells: [
        DataCell(Text(contract.contractCode!)),
        DataCell(Text(contract.objectName!)),
        DataCell(Text(contract.unitNumber)),
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
        DataCell(Text('${contract.userNames} ')),
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
                color: THelperFunctions.getUnitContractStatusColor(
                  contract.statusId!,
                ),
              ),
            ),
          ),
        ),
        DataCell(
          TTableActionButtons(
            view: true,
            edit: true,
            delete:
                contract.statusId != 1
                    ? contract.statusId != 2
                        ? true
                        : false
                    : false,
            terminateContract: contract.statusId == 1 ? true : false,
            onTerminateContractPressed: () async {
              final currentContract = contract;

              var updatedContract = currentContract;
              updatedContract.statusId = 2; // 2 = Terminated
              updatedContract.endDate = DateTime.now(); // Set end date to now

              final updatedResult = await controller.submitContractTerminate(
                updatedContract,
              );
              if (updatedResult) {
                controller.isDataUpdated.value = true;

                //  Replace the updated contract in the list

                contract.statusId = 2;
                contract.endDate = DateTime.now();
                controller.filteredItems.refresh();
              }
            },

            onViewPressed: () async {
              // controller.contractModel.value.tenants = contract.tenants;
              // controller.contractModel.refresh();
              // controller.loadTenants();

              // debugPrint(
              //   'Contract FULL Name: ${controller.contractModel.value.tenants!.map((e) => e.fullName).join(', ')}',
              // );

              Get.toNamed(Routes.contractDetails, arguments: contract)?.then((
                result,
              ) async {
                if (result == true) {
                  final controllerContract = ContractController.instance;

                  contract.contractCode =
                      controllerContract.contractModel.value.contractCode;
                  contract.startDate =
                      controllerContract.contractModel.value.startDate;
                  contract.endDate =
                      controllerContract.contractModel.value.endDate;
                  contract.userCount =
                      controllerContract.contractModel.value.userCount;
                  contract.userNames =
                      controllerContract.contractModel.value.userNames;
                  contract.statusId =
                      controllerContract.contractModel.value.statusId;
                  contract.users =
                      controllerContract.contractModel.value.users;

                  notifyListeners();
                }
              });
            },
            onEditPressed: () async {
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
                controller.isDataUpdated.value = true;

                contract.statusId = updatedContract.statusId;
                contract.contractCode = updatedContract.contractCode;
                contract.startDate = updatedContract.startDate;
                contract.endDate = updatedContract.endDate;
                contract.userCount = updatedContract.userCount;
                contract.userNames = updatedContract.userNames;
                contract.userCount = updatedContract.userCount;
                controller.filteredItems.refresh();
              }
            },

            onDeletePressed: () => controller.confirmAndDeleteItem(contract),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.filteredItems.length;

  @override
  int get selectedRowCount =>
      controller.selectedRows.where((selected) => selected).length;
}
