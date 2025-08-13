import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/features/personalization/controllers/company_controller.dart';
import 'package:xm_frontend/features/shop/controllers/object/object_controller.dart';
//import 'package:xm_frontend/features/shop/controllers/user/user_controller.dart';

import '../../../../../../../common/widgets/data_table/paginated_data_table.dart';
import 'table_source.dart';

class CompaniesTable extends StatelessWidget {
  const CompaniesTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CompanyController>();

    // add post frame callback to ensure data is loaded after first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.filteredItems.isEmpty) {
        controller.refreshData();
      }
    });

    return Obx(() {
      // Force Obx update when company list or selection changes
      Visibility(
        visible: false,
        child: Text(controller.filteredItems.length.toString()),
      );
      Visibility(
        visible: false,
        child: Text(controller.selectedRows.length.toString()),
      );
       print('Building CompaniesTable: filteredItems.length=${controller.filteredItems.length}, selectedRows.length=${controller.selectedRows.length}');

  if (controller.filteredItems.length != controller.selectedRows.length) {
    // Wait until both lists are in sync before building the table
        print('Lengths do not match, showing spinner');
    return const Center(child: CircularProgressIndicator());
  }
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
    AppLocalization.of(context).translate('tab_users_screen.lbl_phone_no'),
  ),
  onSort: (columnIndex, ascending) => controller.sortByPropertyName(
    columnIndex,
    ascending,
    (u) => u.phone.toString(),
  ),
),
DataColumn2(
  size: ColumnSize.M,
  label: Text(
    AppLocalization.of(context).translate('tab_users_screen.lbl_status'),
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
        source: CompanyRows(),
      );
    });
  }
}
