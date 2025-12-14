import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cartakers/app/localization/app_localization.dart';
import 'package:cartakers/features/shop/controllers/contract/permission_controller.dart';
import 'package:cartakers/features/personalization/controllers/user_controller.dart';
import '../../../../../../common/widgets/data_table/paginated_data_table.dart';
import 'table_source.dart';

class PermissionsTable extends StatelessWidget {
  const PermissionsTable  ({super.key});

  @override
  Widget build(BuildContext context) {
    final controllerUser = Get.find<UserController>();
    final selectedUserId = int.tryParse(controllerUser.userModel.value.id.toString()) ?? 0;
    final controller = Get.find<PermissionController>();
    debugPrint('Selected User ID: $selectedUserId');
    debugPrint('All Permissions: ${controller.allPermissions.length}');
    controller.filterPermissionsByUserId(selectedUserId);
    debugPrint('Filtered Permissions for id $selectedUserId: ${controller.userPermissions.length}');

  // Schedule filtering after build
  WidgetsBinding.instance.addPostFrameCallback((_) {
    controller.filterPermissionsByUserId(selectedUserId);
    controller.refreshData();
  });

    return Obx(() {
      // Trigger UI update on reactive changes
      Visibility(
        visible: false,
        child: Text(controller.userPermissions.length.toString()),
      );
      Visibility(
        visible: false,
        child: Text(controller.userPermissions.length.toString()),
      );
      debugPrint('PermissionsTable: userPermissions.length = ${controller.userPermissions.length}');

      return TPaginatedDataTable(
        minWidth: 1100, // minimum table width
        sortAscending: controller.sortAscending.value,
        sortColumnIndex: controller.sortColumnIndex.value,
        onPaginationReset: () => controller.paginatedPage.value = 0,
        columns: [
          DataColumn2(
            fixedWidth: 200,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('unit_detail_screen.lbl_contract_reference'),
            ),
            onSort:
                (columnIndex, ascending) =>
                    controller.sortByName(columnIndex, ascending),
          ),
          DataColumn2(
            fixedWidth: 180,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('objects_screen.lbl_object_name'),
            ),
            onSort:
                (columnIndex, ascending) =>
                    controller.sortByObject(columnIndex, ascending),
          ),
          DataColumn2(
            fixedWidth: 180,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('users_screen.lbl_user_name'),
            ),
            onSort:
                (columnIndex, ascending) =>
                    controller.sortByObject(columnIndex, ascending),
          ),
                    DataColumn2(
            fixedWidth: 180,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('users_screen.lbl_role'),
            ),
            onSort:
                (columnIndex, ascending) =>
                    controller.sortByObject(columnIndex, ascending),
          ),
          DataColumn2(
            fixedWidth: 150,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('objects_screen.lbl_actions'),
            ),
          ),
        ],
        source: PermissionsRows(),
      );
    });
  }
}
