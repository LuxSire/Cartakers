import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/features/shop/controllers/object/edit_object_controller.dart';
import '../../../../../../common/widgets/data_table/paginated_data_table.dart';
import 'table_source.dart';

class ObjectUnitTable extends StatelessWidget {
  const ObjectUnitTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = EditObjectController.instance;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth > 800;

        return Obx(() {
          // Hidden reactive watchers to trigger rebuilds
          Visibility(
            visible: false,
            child: Text(controller.filteredObjectUnits.length.toString()),
          );
          Visibility(
            visible: false,
            child: Text(controller.selectedRows.length.toString()),
          );

          return TPaginatedDataTable(
            minWidth: 600,
            tableHeight: 640,
            dataRowHeight: kMinInteractiveDimension,
            sortAscending: controller.sortAscending.value,
            sortColumnIndex: controller.sortColumnIndex.value,
            columns: [
              DataColumn2(
                fixedWidth: isWideScreen ? 100 : null,
                label: Text(
                  AppLocalization.of(
                    context,
                  ).translate('edit_object_screen.lbl_unit_#'),
                ),
                onSort:
                    (columnIndex, ascending) =>
                        controller.sortById(columnIndex, ascending),
              ),
              DataColumn2(
                fixedWidth: isWideScreen ? 80 : null,
                label: Text(
                  AppLocalization.of(
                    context,
                  ).translate('edit_object_screen.lbl_floor'),
                ),
              ),
              DataColumn2(
                fixedWidth: isWideScreen ? 80 : null,
                label: Text(
                  AppLocalization.of(
                    context,
                  ).translate('edit_object_screen.lbl_room'),
                ),
              ),
              DataColumn2(
                label: Text(
                  AppLocalization.of(
                    context,
                  ).translate('edit_object_screen.lbl_description'),
                ),
              ),
              DataColumn2(
                fixedWidth: isWideScreen ? 120 : null,
                label: Text(
                  AppLocalization.of(
                    context,
                  ).translate('edit_object_screen.lbl_status'),
                ),
              ),
              DataColumn2(
                label: Text(
                  AppLocalization.of(
                    context,
                  ).translate('edit_object_screen.lbl_updated_on'),
                ),
              ),
              DataColumn2(
                fixedWidth: isWideScreen ? 100 : null,
                label: Text(
                  AppLocalization.of(
                    context,
                  ).translate('objects_screen.lbl_actions'),
                ),
              ),
            ],
            source: ObjectUnitsRows(),
          );
        });
      },
    );
  }
}
