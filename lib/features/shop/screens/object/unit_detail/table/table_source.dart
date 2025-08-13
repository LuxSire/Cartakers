import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:path/path.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/data/models/permission_model.dart';
import 'package:xm_frontend/features/shop/controllers/object/object_unit_detail_controller.dart';
import 'package:xm_frontend/features/shop/controllers/object/edit_object_controller.dart';
import 'package:xm_frontend/features/shop/controllers/contract/permission_controller.dart';
import 'package:xm_frontend/features/shop/screens/contract/dialogs/edit_contract.dart';
import 'package:xm_frontend/routes/routes.dart';
import 'package:xm_frontend/utils/constants/sizes.dart';
import 'package:xm_frontend/utils/helpers/helper_functions.dart';
import 'package:xm_frontend/utils/popups/dialogs.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/colors.dart';

class ObjectUnitContractsRows extends DataTableSource {
  final controller = ObjectUnitDetailController.instance;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.filteredObjectUnitContracts.length;

  @override
  int get selectedRowCount =>
      controller.selectedRows.where((selected) => selected).length;

  @override
  DataRow? getRow(int index) {
    final contract = controller.filteredObjectUnitContracts[index];
    return DataRow2(
      specificRowHeight: 80,
      onTap: () {
        Get.toNamed(Routes.permissionDetails, arguments: contract)?.then((
          result,
        ) async {
          if (result == true) {
            final controllerContract = PermissionController.instance;


            final controllerUnitDetail = ObjectUnitDetailController.instance;


         
            await controller.getUsersOfCurrentUnit();

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
            contract.permissionId.toString()!,
            style: Theme.of(
              Get.context!,
            ).textTheme.bodyLarge!.apply(color: TColors.primary),
          ),
        ),
        DataCell(Text(contract.formattedStartDate)),
       
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


}
