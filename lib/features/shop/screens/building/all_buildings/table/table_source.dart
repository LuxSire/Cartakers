import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/features/shop/controllers/building/building_controller.dart';
import 'package:xm_frontend/features/shop/controllers/building/edit_building_controller.dart';
import 'package:xm_frontend/routes/routes.dart';

import '../../../../../../common/widgets/icons/table_action_icon_buttons.dart';
import '../../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';

class BuildingRows extends DataTableSource {
  final controller = BuildingController.instance;

  @override
  DataRow? getRow(int index) {
    final building = controller.filteredItems[index];
    return DataRow2(
      onTap: () {
        Get.toNamed(Routes.editBuilding, arguments: building)?.then((result) {
          if (result == true) {
            controller.refreshData(); // Force re-fetch on return
          }
        });
      },
      selected: controller.selectedRows[index],
      onSelectChanged:
          (value) => controller.selectedRows[index] = value ?? false,
      cells: [
        DataCell(
          Row(
            children: [
              TRoundedImage(
                width: 50,
                height: 50,
                padding: TSizes.sm,
                image: building.imgUrl,
                imageType: ImageType.network,
                borderRadius: TSizes.borderRadiusMd,
                backgroundColor: TColors.primaryBackground,
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              Expanded(
                child: Text(
                  building.name!,
                  style: Theme.of(
                    Get.context!,
                  ).textTheme.bodyLarge!.apply(color: TColors.primary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        DataCell(Text(building.street!)),
        DataCell(Text(building.buildingNumber!.toString())),
        DataCell(Text(building.zipCode!)),
        DataCell(Text(building.location!)),
        DataCell(Text(building.totalUnits.toString())),
        DataCell(Text(building.totalFloors.toString())),
        DataCell(
          Text(building.createdAt == null ? '' : building.formattedDate),
        ),
        DataCell(
          TTableActionButtons(
            view: true,
            edit: false,
            onViewPressed: () {
              Get.toNamed(Routes.editBuilding, arguments: building)?.then((
                result,
              ) {
                if (result == true) {
                  controller.refreshData(); // Force re-fetch on return
                }
              });
            },
            onDeletePressed: () => controller.confirmAndDeleteItem(building),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.filteredItems.length;

  @override
  int get selectedRowCount =>
      controller.selectedRows.where((selected) => selected).length;
}
