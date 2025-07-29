import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/features/personalization/controllers/user_controller.dart';
import 'package:xm_frontend/features/shop/controllers/building/building_controller.dart';
import 'package:xm_frontend/features/shop/controllers/tenant/tenant_controller.dart';

import '../../../../../../common/widgets/data_table/paginated_data_table.dart';
import 'table_source.dart';

class UsersTable extends StatelessWidget {
  const UsersTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());

    // add post frame callback to ensure data is loaded after first build
    //  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (controller.filteredItems.isEmpty) {
      controller.refreshData();
    }
    // });

    return Obx(() {
      // Force Obx update when tenant list or selection changes
      Visibility(
        visible: false,
        child: Text(controller.filteredItems.length.toString()),
      );
      Visibility(
        visible: false,
        child: Text(controller.selectedRows.length.toString()),
      );

      return TPaginatedDataTable(
        minWidth: 1100, // Match with BuildingTable or use 700 if more compact
        sortAscending: controller.sortAscending.value,
        sortColumnIndex: controller.sortColumnIndex.value,
        onPaginationReset: () => controller.paginatedPage.value = 0,
        columns: [
          DataColumn2(
            size: ColumnSize.L,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('tab_users_screen.lbl_name'),
            ),
            onSort:
                (columnIndex, ascending) => controller.sortByPropertyName(
                  columnIndex,
                  ascending,
                  (u) => u.fullName.toLowerCase(),
                ),
          ),
          DataColumn2(
            size: ColumnSize.L,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('tab_users_screen.lbl_email'),
            ),
            onSort:
                (columnIndex, ascending) => controller.sortByPropertyName(
                  columnIndex,
                  ascending,
                  (u) => u.email.toLowerCase(),
                ),
          ),

          DataColumn2(
            size: ColumnSize.M,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('tab_users_screen.lbl_role'),
            ),
            onSort:
                (columnIndex, ascending) => controller.sortByPropertyName(
                  columnIndex,
                  ascending,
                  (u) => u.translatedRoleNameExt.toString(),
                ),
          ),
          DataColumn2(
            size: ColumnSize.M,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('tab_users_screen.lbl_buildings'),
            ),
            onSort:
                (columnIndex, ascending) => controller.sortByPropertyName(
                  columnIndex,
                  ascending,
                  (u) => u.buildingPermissions.toString(),
                ),
          ),

          DataColumn2(
            size: ColumnSize.M,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('tab_users_screen.lbl_status'),
            ),
            onSort:
                (columnIndex, ascending) => controller.sortByPropertyName(
                  columnIndex,
                  ascending,
                  (u) => u.translatedStatus.toString(),
                ),
          ),
          DataColumn2(
            size: ColumnSize.M,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('tab_users_screen.lbl_date_created'),
            ),
            onSort:
                (columnIndex, ascending) => controller.sortByPropertyName(
                  columnIndex,
                  ascending,
                  (u) => u.createdAt!,
                ),
          ),
          DataColumn2(
            size: ColumnSize.M,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('tab_users_screen.lbl_actions'),
            ),
          ),
        ],
        source: UserRows(),
      );
    });
  }
}
