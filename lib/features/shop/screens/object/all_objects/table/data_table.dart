import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cartakers/app/localization/app_localization.dart';
import 'package:cartakers/features/shop/controllers/object/object_controller.dart';

import '../../../../../../common/widgets/data_table/paginated_data_table.dart';
import 'table_source.dart';

class ObjectTable extends StatelessWidget {
  const ObjectTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ObjectController>();

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

    return Center(
      child: Card(
        elevation: 18, // Higher elevation for more "3D" effect
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        margin: const EdgeInsets.all(32),
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: TPaginatedDataTable(
            minWidth: 1100,
            sortAscending: controller.sortAscending.value,
            sortColumnIndex: controller.sortColumnIndex.value,
            columns: [
          DataColumn2(
            fixedWidth: 400,
            headingRowAlignment: MainAxisAlignment.center,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('objects_screen.lbl_object_name'),
            ),
            onSort:
                (columnIndex, ascending) =>
                    controller.sortByName(columnIndex, ascending),
          ),
/*          DataColumn2(
            size: ColumnSize.M,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('objects_screen.lbl_street'),
            ),
          ),*/

          DataColumn2(
            size: ColumnSize.M,
            headingRowAlignment: MainAxisAlignment.start,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('objects_screen.lbl_state'),
            ),
          ),
          /*
          DataColumn2(
            size: ColumnSize.S,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('objects_screen.lbl_zip_code'),
            ),
          ),
*/

          DataColumn2(
            size: ColumnSize.M,
            headingRowAlignment: MainAxisAlignment.start,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('objects_screen.lbl_country'),
            ),
          ),
          DataColumn2(
            size: ColumnSize.S,
            headingRowAlignment: MainAxisAlignment.start,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('objects_screen.lbl_type'),
            ),
          ),
          DataColumn2(
            size: ColumnSize.S,
            headingRowAlignment: MainAxisAlignment.start,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('objects_screen.lbl_zoning'),
            ),
          ),
          DataColumn2(
            size: ColumnSize.M,
            headingRowAlignment: MainAxisAlignment.center,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('objects_screen.lbl_price'),
            ),
          ),
                    DataColumn2(
            size: ColumnSize.M,
            headingRowAlignment: MainAxisAlignment.center,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('objects_screen.lbl_grossyield'),
            ),
          ),
          DataColumn2(
            fixedWidth: 100,
            headingRowAlignment: MainAxisAlignment.center,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('objects_screen.lbl_actions'),
            ),
          ),
        ],

        source: ObjectRows(),
         ),
        ),
      ),
    );
  });
}
}
