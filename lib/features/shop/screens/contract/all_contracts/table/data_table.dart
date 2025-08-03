import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/features/shop/controllers/contract/contract_controller.dart';

import '../../../../../../common/widgets/data_table/paginated_data_table.dart';
import 'table_source.dart';

class ContractsTable extends StatelessWidget {
  const ContractsTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ContractController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.refreshData();
    });

    return Obx(() {
      // Trigger UI update on reactive changes
      Visibility(
        visible: false,
        child: Text(controller.filteredItems.length.toString()),
      );
      Visibility(
        visible: false,
        child: Text(controller.selectedRows.length.toString()),
      );

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
            size: ColumnSize.S,
            label: Text(
              AppLocalization.of(context).translate('contract_screen.lbl_unit'),
            ),

            onSort:
                (columnIndex, ascending) =>
                    controller.sortByUnit(columnIndex, ascending),
          ),
          DataColumn2(
            size: ColumnSize.S,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('unit_detail_screen.lbl_start_date'),
            ),
            onSort:
                (columnIndex, ascending) =>
                    controller.sortByStartDate(columnIndex, ascending),
          ),
          DataColumn2(
            size: ColumnSize.S,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('unit_detail_screen.lbl_end_date'),
            ),
            onSort:
                (columnIndex, ascending) =>
                    controller.sortByEndDate(columnIndex, ascending),
          ),
          DataColumn2(
            size: ColumnSize.M,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('unit_detail_screen.lbl_tenants'),
            ),
          ),
          DataColumn2(
            size: ColumnSize.S,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('unit_detail_screen.lbl_status'),
            ),
            onSort:
                (columnIndex, ascending) =>
                    controller.sortByStatus(columnIndex, ascending),
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
        source: ContractsRows(),
      );
    });
  }
}
