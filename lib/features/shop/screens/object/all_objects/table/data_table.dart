import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/features/shop/controllers/object/object_controller.dart';

import '../../../../../../common/widgets/data_table/paginated_data_table.dart';
import 'table_source.dart';

class ObjectTable extends StatelessWidget {
  const ObjectTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ObjectController());

    // add post frame callback to ensure data is loaded after first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.filteredItems.isEmpty) {
        controller.loadAllObjects();
        //  controller.refreshData();
      }
    });

    return Obx(() {
      // Buildings & Selected Rows are Hidden => Just to update the UI => Obx => [ProductRows]
      Visibility(
        visible: false,
        child: Text(controller.filteredItems.length.toString()),
      );
      Visibility(
        visible: false,
        child: Text(controller.selectedRows.length.toString()),
      );

      // Table
      return TPaginatedDataTable(
        minWidth: 1100,
        sortAscending: controller.sortAscending.value,
        sortColumnIndex: controller.sortColumnIndex.value,
        columns: [
          DataColumn2(
            fixedWidth: 200,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('objects_screen.lbl_object_name'),
            ),
            onSort:
                (columnIndex, ascending) =>
                    controller.sortByName(columnIndex, ascending),
          ),
          DataColumn2(
            size: ColumnSize.M,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('objects_screen.lbl_street'),
            ),
          ),
          DataColumn2(
            size: ColumnSize.M,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('objects_screen.lbl_object_number'),
            ),
          ),
          DataColumn2(
            size: ColumnSize.S,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('objects_screen.lbl_zip_code'),
            ),
          ),
          DataColumn2(
            size: ColumnSize.M,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('objects_screen.lbl_location'),
            ),
          ),
          DataColumn2(
            size: ColumnSize.S,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('objects_screen.lbl_units'),
            ),
          ),
          DataColumn2(
            size: ColumnSize.S,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('objects_screen.lbl_floors'),
            ),
          ),
          DataColumn2(
            size: ColumnSize.M,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('objects_screen.lbl_date_created'),
            ),
          ),
          DataColumn2(
            fixedWidth: 100,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('objects_screen.lbl_actions'),
            ),
          ),
        ],

        source: ObjectRows(),
      );
    });
  }
}
