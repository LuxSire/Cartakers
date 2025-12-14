import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cartakers/app/localization/app_localization.dart';
import 'package:cartakers/features/shop/controllers/object/edit_object_controller.dart';
import '../../../../../../common/widgets/data_table/paginated_data_table.dart';
import 'table_source.dart';

class ObjectUnitTable extends StatefulWidget {
  const ObjectUnitTable({super.key});
  @override
  State<ObjectUnitTable> createState() => _ObjectUnitTableState();
}

class _ObjectUnitTableState extends State<ObjectUnitTable> {
  late final ObjectUnitsRows _dataSource;

  @override
  void initState() {
    super.initState();
    _dataSource = ObjectUnitsRows();
  }
  @override
  Widget build(BuildContext context) {
    final controller = EditObjectController.instance;


    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth > 700;

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

        return Column
        
        (
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: Text(AppLocalization.of(context).translate('edit_object_screen.btn_create_unit')),
                onPressed: () async {
                  // Call your create-unit logic here
                  await controller.CreateUnit(controller.objectInstance);
                  // Optionally refresh the table/list after creation
                  await controller.loadAllUnits();
                },
              ),
            ),

          Expanded(  
            child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            
            child: TPaginatedDataTable(
            minWidth: 1800,
            tableHeight: 640,
            dataRowHeight: kMinInteractiveDimension,
            sortAscending: controller.sortAscending.value,
            sortColumnIndex: controller.sortColumnIndex.value,
            columns: [
              DataColumn2(
                fixedWidth: isWideScreen ? 100 : 80,
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
                fixedWidth: isWideScreen ? 80 : 60,
                label: Text(
                  AppLocalization.of(
                    context,
                  ).translate('edit_object_screen.lbl_floor'),
                ),
              ),
              DataColumn2(
                fixedWidth: isWideScreen ? 150 : 120,
                label: Text(
                  AppLocalization.of(
                    context,
                  ).translate('edit_object_screen.lbl_sqm'),
                ),
              ),
              DataColumn2(
                fixedWidth: isWideScreen ? 450 : 350,
                headingRowAlignment: MainAxisAlignment.center,
                label: Text(
                  AppLocalization.of(
                    context,
                  ).translate('edit_object_screen.lbl_description'),
                ),
              ),
              DataColumn2(
                fixedWidth: isWideScreen ? 120 : 80,
                label: Text(
                  AppLocalization.of(
                    context,
                  ).translate('edit_object_screen.lbl_status'),
                ),
              ),
                DataColumn2(
                fixedWidth: isWideScreen ? 180 : 140,
                label: Text(
                  AppLocalization.of(
                    context,
                  ).translate('objects_screen.lbl_actions'),
                ),
              ),
            ],
            source:  _dataSource, 
            ),
            ),
          ),
          ],
        );
        });
      },
    );
  }
}
