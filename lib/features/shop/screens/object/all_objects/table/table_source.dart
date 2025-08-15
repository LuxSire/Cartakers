import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/features/shop/controllers/object/object_controller.dart';
import 'package:xm_frontend/features/shop/controllers/object/edit_object_controller.dart';
import 'package:xm_frontend/routes/routes.dart';

import '../../../../../../common/widgets/icons/table_action_icon_buttons.dart';
import '../../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';

class ObjectRows extends DataTableSource {
  final controller = ObjectController.instance;

  @override
  DataRow? getRow(int index) {
    final object = controller.allObjects[index];
    return DataRow2(
      onTap: () {
        Get.toNamed(Routes.editObject, arguments: object)?.then((result) {
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
                image: object.imgUrl ??  'assets/images/app_icon.png',
                imageType: (object.imgUrl != null && object.imgUrl!.isNotEmpty)
                ? ImageType.network
              : ImageType.asset,

                borderRadius: TSizes.borderRadiusMd,
                backgroundColor: TColors.primaryBackground,
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              Expanded(
                child: Text(
                  object.name!,
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
        DataCell(Text(object.street ?? '')),
DataCell(Text(object.city?.toString() ?? '')),
DataCell(Text(object.zipCode ?? '')),
DataCell(Text(object.country ?? '')),
DataCell(Text(object.type_?.toString() ?? '')),
DataCell(Text(object.zoning?.toString() ?? '')),
DataCell(Text(object.price.toString() ?? '')),
        DataCell(
          TTableActionButtons(
            view: true,
            edit: false,
            onViewPressed: () {
              Get.toNamed(Routes.editObject, arguments: object)?.then((
                result,
              ) {
                if (result == true) {
                  controller.refreshData(); // Force re-fetch on return
                }
              });
            },
            onDeletePressed: () => controller.deleteItem(object),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.allObjects.length;

  @override
  int get selectedRowCount =>
      controller.selectedRows.where((selected) => selected).length;
}
