import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/features/shop/controllers/communication/communication_controller.dart';
import 'package:xm_frontend/data/models/object_model.dart';
import '../../../../../../../common/widgets/data_table/paginated_data_table.dart';
import 'table_source.dart';

class MessageTable extends StatelessWidget {
  const MessageTable({super.key,this.object});

  final ObjectModel? object;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CommunicationController>();
    controller.selectedObject.value = object;

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

DropdownButton<int>(
  value: controller.selectedObjectId.value == -1 ? null : controller.selectedObjectId.value,
  items: [
    DropdownMenuItem<int>(
      value: -1,
      child: Text('All objects'),
    ),
    ...controller.objectsList.map((obj) {
      return DropdownMenuItem<int>(
        value: obj.id,
        child: Text(obj.description ?? ''),
      );
    }).toList(),
  ],
  onChanged: (id) {
    controller.selectedObjectId.value = id ?? -1;
    controller.filterMessagesBySelectedObject();
  },
);

      // Table
      return TPaginatedDataTable(
        minWidth: 1100,
        sortAscending: controller.sortAscending.value,
        sortColumnIndex: controller.sortColumnIndex.value,
        columns: [
          DataColumn2(
            fixedWidth: 250,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('communication_screen.lbl_date'),
            ),
            // onSort:
            //     (columnIndex, ascending) =>
            //         controller.sortByName(columnIndex, ascending),
          ),
          DataColumn2(
            size: ColumnSize.M,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('communication_screen.lbl_title'),
            ),
          ),
          DataColumn2(
            size: ColumnSize.M,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('communication_screen.lbl_sender'),
            ),
          ),
          DataColumn2(
            size: ColumnSize.S,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('communication_screen.lbl_object'),
            ),
          ),
          DataColumn2(
            size: ColumnSize.M,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('communication_screen.lbl_status'),
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

        source: MessageRows(controller.filteredItems),
      );
    });
  }
}
