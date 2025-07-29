import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/features/shop/controllers/building/building_unit_detail_controller.dart';
import 'package:xm_frontend/features/shop/controllers/building/edit_building_controller.dart';
import 'package:xm_frontend/features/shop/controllers/customer/customer_detail_controller.dart';
import 'package:xm_frontend/utils/device/device_utility.dart';

import '../../../../../../common/widgets/data_table/paginated_data_table.dart';
import 'table_source.dart';

class BuildingUnitContractTable extends StatelessWidget {
  const BuildingUnitContractTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = BuildingUnitDetailController.instance;
    return Obx(() {
      // Units & Selected Rows are Hidden => Just to update the UI => Obx => []
      Visibility(
        visible: false,
        child: Text(controller.filteredBuildingUnitContracts.length.toString()),
      );
      Visibility(
        visible: false,
        child: Text(controller.selectedRows.length.toString()),
      );

      // Table
      return TPaginatedDataTable(
        minWidth: 550,
        tableHeight: 640,
        dataRowHeight: kMinInteractiveDimension,
        sortAscending: controller.sortAscending.value,
        sortColumnIndex: controller.sortColumnIndex.value,
        columns: [
          DataColumn2(
            label: Text(
              AppLocalization.of(
                context,
              ).translate('unit_detail_screen.lbl_contract_reference'),
            ),
            onSort:
                (columnIndex, ascending) =>
                    controller.sortById(columnIndex, ascending),
          ),
          DataColumn2(
            label: Text(
              AppLocalization.of(
                context,
              ).translate('unit_detail_screen.lbl_start_date'),
            ),
          ),
          DataColumn2(
            label: Text(
              AppLocalization.of(
                context,
              ).translate('unit_detail_screen.lbl_end_date'),
            ),
          ),
          DataColumn2(
            label: Text(
              AppLocalization.of(
                context,
              ).translate('unit_detail_screen.lbl_tenants'),
            ),
          ),
          DataColumn2(
            label: Text(
              AppLocalization.of(
                context,
              ).translate('unit_detail_screen.lbl_status'),
            ),
          ),
          DataColumn2(
            label: Text(
              AppLocalization.of(
                context,
              ).translate('buildings_screen.lbl_actions'),
            ),
          ),
        ],
        source: BuildingUnitContractsRows(),
      );
    });
  }
}
