import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/common/widgets/icons/table_action_icon_buttons.dart';
import 'package:xm_frontend/data/models/permission_model.dart';
import 'package:xm_frontend/features/shop/controllers/object/object_unit_detail_controller.dart';
import 'package:xm_frontend/features/shop/controllers/object/edit_object_controller.dart';
import 'package:xm_frontend/features/shop/controllers/contract/permission_controller.dart';
import 'package:xm_frontend/features/shop/screens/contract/dialogs/edit_contract.dart';
import 'package:xm_frontend/routes/routes.dart';
import 'package:xm_frontend/utils/constants/sizes.dart';
import 'package:xm_frontend/utils/helpers/helper_functions.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/colors.dart';

class PermissionsRows extends DataTableSource {
 final controller = Get.find<PermissionController>();
 
 PermissionsRows() {
  debugPrint('PermissionsRows constructed');
}

  @override
  DataRow? getRow(int index) {
      debugPrint('[PermissionsRows] filteredPermissions.length: ${controller.userPermissions.length}');
      debugPrint('[PermissionsRows] index: $index');

    if (index >= controller.userPermissions.length)
      return null; // prevent overflow

    final permission = controller.userPermissions[index];
    return DataRow2(
      specificRowHeight: 80,
      onTap: () {
        Get.toNamed(Routes.permissionDetails, arguments: permission)?.then((
          result,
        ) async {
          if (result == true) {
            final controllerContract = PermissionController.instance;


            notifyListeners();
          }
        });
      },

      selected: controller.selectedRows[index],
      cells: [
        DataCell(Text(permission.permissionId.toString())),
        DataCell(Text(permission.objectName!)),
        DataCell(Text(permission.userName!)),
        DataCell(Text(permission.roleName!)),
        DataCell(
          TTableActionButtons(
            edit: true,
            delete: true,
            onDeletePressed: () async {
              await controller.removePermission(permission);
              controller.refreshData();
            },
          ),
        ),
        
        
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.userPermissions.length;

  @override
  int get selectedRowCount =>
      controller.selectedRows.where((selected) => selected).length;
}
