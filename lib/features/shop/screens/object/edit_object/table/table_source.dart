import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/common/widgets/icons/table_action_icon_buttons.dart';
import 'package:xm_frontend/data/models/unit_room_model.dart';
import 'package:xm_frontend/features/shop/controllers/object/object_unit_detail_controller.dart';
import 'package:xm_frontend/features/shop/controllers/object/edit_object_controller.dart';
import 'package:xm_frontend/routes/routes.dart';
import 'package:xm_frontend/utils/constants/sizes.dart';
import 'package:xm_frontend/utils/helpers/helper_functions.dart';

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

        DataCell(Text('${unit.userNames}')),
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
        DataCell(Text(unit.contractCode!)),

        DataCell(Text(unit.formattedDate)),
        DataCell(
          TTableActionButtons(
            view: true,
            edit: false,
            delete: false,
            onViewPressed: () {
              Get.toNamed(Routes.unitDetails, arguments: unit)?.then((result) {
                // debugPrint('Result from unit detail screen: $result');
                if (result == true) {
                  //     debugPrint('Result is true, updating unit');

                  // update that row
                  final controllerUnitDetail =
                      ObjectUnitDetailController.instance;

                  unit.userCount =
                      controllerUnitDetail.unit.value.userCount;
                  unit.userNames =
                      controllerUnitDetail.unit.value.userNames;
                  unit.statusId = controllerUnitDetail.unit.value.statusId;
                  unit.contractCode =
                      controllerUnitDetail.unit.value.contractCode;
                  unit.updatedAt = controllerUnitDetail.unit.value.updatedAt;
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
