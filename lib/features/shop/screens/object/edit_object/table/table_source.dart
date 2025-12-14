import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cartakers/common/widgets/icons/table_action_icon_buttons.dart';
import 'package:cartakers/data/models/unit_room_model.dart';
import 'package:cartakers/features/shop/controllers/object/object_unit_detail_controller.dart';
import 'package:cartakers/features/shop/controllers/object/edit_object_controller.dart';
import 'package:cartakers/routes/routes.dart';
import 'package:cartakers/utils/constants/sizes.dart';
import 'package:cartakers/utils/helpers/helper_functions.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/colors.dart';

class ObjectUnitsRows extends DataTableSource {
  final controller = EditObjectController.instance;

  ObjectUnitsRows() {
    controller.allObjectUnits();
  }

  @override
  DataRow? getRow(int index) {
    final unit = controller.filteredObjectUnits[index];
    return DataRow2(
      specificRowHeight: 80,

      //  onTap: () => Get.toNamed(Routes.unitDetails, arguments: unit),
      selected: controller.selectedRows[index],
      cells: [
        DataCell(
          Text(
            unit.unitNumber!,
            style: Theme.of(
              Get.context!,
            ).textTheme.bodyLarge!.apply(color: TColors.primary),
          ),
        ),
        DataCell(Text(unit.floorNumber!)),
        DataCell(Text(unit.sqm.toString()!)),
        /*
        DataCell(
          // wrap in Obx so it rebuilds when controller.unitListRooms changes
          Obx(() {
            // Find the currently selected room-model
            final currentRoom = controller.unitListRooms.firstWhere(
              (r) => r.piece == unit.pieceName,
              orElse: () => UnitRoomModel(id: '0', piece: unit.pieceName ?? ''),
            );

            return DropdownButton<UnitRoomModel>(
              value: currentRoom,
              isDense: true,
              underline: const SizedBox.shrink(),
              onChanged: (newRoom) {
                if (newRoom != null && newRoom.id != currentRoom.id) {
                  controller.updateUnitRoom(unit, newRoom);

                  controller.unitListRooms.refresh();
                  controller.filteredObjectUnits.refresh();
                }
              },
              items:
                  controller.unitListRooms.map((room) {
                    return DropdownMenuItem(
                      value: room,
                      child: Text(
                        room.piece!,
                        style: Theme.of(Get.context!).textTheme.bodySmall,
                      ),
                    );
                  }).toList(),
            );
          }),
        ),
*/
        DataCell(Text('${unit.description}')),
        DataCell(
          TRoundedContainer(
            radius: TSizes.cardRadiusSm,
            padding: const EdgeInsets.symmetric(
              vertical: TSizes.sm,
              horizontal: TSizes.md,
            ),
            backgroundColor: THelperFunctions.getUnitStatusColor(
              unit.statusId!,
            ).withOpacity(0.1),
            child: Text(
              THelperFunctions.getUnitStatusText(unit.statusId!),
              style: TextStyle(
                color: THelperFunctions.getUnitStatusColor(unit.statusId!),
              ),
            ),
          ),
        ),

      
        DataCell(
          TTableActionButtons(
            view: false,
            edit: true,
            delete: true,
            onDeletePressed: () async {
              debugPrint('Delete pressed for unit: ${unit.toJson()}');
              final result = await controller.deleteItem(unit);
              if (result == true) 
                  {
                  notifyListeners(); // <-- This will refresh the table
                  }
            },
            onEditPressed: () {
               debugPrint('Edit pressed for unit: ${unit.toJson()}');
               Get.toNamed(Routes.unitDetails, arguments: unit)?.then((result) {
                // debugPrint('Result from unit detail screen: $result');
                if (result == true) {
                  //     debugPrint('Result is true, updating unit');

                  // update that row
                  debugPrint('Updated unit: ${unit.toJson()}');
                  notifyListeners();
                }
              });
            },
           
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.filteredObjectUnits.length;

  @override
  int get selectedRowCount =>
      controller.selectedRows.where((selected) => selected).length;
}
