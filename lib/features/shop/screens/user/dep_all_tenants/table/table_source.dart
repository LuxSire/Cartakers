import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cartakers/app/localization/app_localization.dart';
import 'package:cartakers/common/widgets/containers/rounded_container.dart';
import 'package:cartakers/common/widgets/images/t_circular_image.dart';
import 'package:cartakers/features/personalization/models/user_model.dart';
import 'package:cartakers/features/shop/controllers/object/object_controller.dart';
import 'package:cartakers/features/shop/controllers/object/edit_object_controller.dart';
import 'package:cartakers/features/shop/controllers/contract/permission_controller.dart';
import 'package:cartakers/features/personalization/controllers/user_controller.dart';
//import 'package:cartakers/features/shop/controllers/user/user_controller.dart';
import 'package:cartakers/features/shop/screens/user/dialogs/dep_edit_user.dart';
import 'package:cartakers/routes/routes.dart';
import 'package:cartakers/utils/constants/image_strings.dart';
import 'package:cartakers/utils/helpers/helper_functions.dart';

import '../../../../../../common/widgets/icons/table_action_icon_buttons.dart';
import '../../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';

class UsersRows extends DataTableSource {
  final controller = UserController.instance;

  // TenantsRows() {
  //   controller.refreshData();
  // }
  
  @override
  DataRow? getRow(int index) {
    if (index >= controller.filteredItems.length)
      return null; // prevent overflow

    final user = controller.filteredItems[index];
    return DataRow2(
      onTap: () async {
        final controllerContract = Get.put(PermissionController());

        controllerContract.initializeContractData(user.userContractId!);

        //  controllerContract.contractModel.value;

        final result = await Get.toNamed(
          Routes.userDetails,
          arguments: user,
        );

        if (result == true) {
          final updatedUser = controller.userModel.value;
          final index = controller.filteredItems.indexWhere(
            (t) => t.id == updatedUser.id,
          );
          if (index != -1) {
            controller.filteredItems[index] = updatedUser;
            controller.filteredItems.refresh();
          }
        }
      },
      selected: controller.selectedRows[index],
      onSelectChanged:
          (value) => controller.selectedRows[index] = value ?? false,
      cells: [
        DataCell(
          Row(
            children: [
              TCircularImage(
                width: 30,
                height: 30,
                padding: 2,
                fit: BoxFit.cover,
                backgroundColor: TColors.primaryBackground,
                image:
                    user.profilePicture.isNotEmpty
                        ? user.profilePicture
                        : TImages.user,
                imageType:
                    user.profilePicture.isNotEmpty
                        ? ImageType.network
                        : ImageType.asset,
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user.fullName,

                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (user.isPrimaryUser == 1) ...[
                      Text(
                        AppLocalization.of(
                          Get.context!,
                        ).translate('users_screen.lbl_primary_user'),
                        style: TextStyle(
                          color: TColors.alterColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        DataCell(Text(user.fullName!)),
        DataCell(Text(user.email)),
        DataCell(Text(user.phoneNumber!)),
        DataCell(Text(user.displayName!)),
        DataCell(Text(user.companyName!)),
        DataCell(
          TRoundedContainer(
            radius: TSizes.cardRadiusSm,
            padding: const EdgeInsets.symmetric(
              vertical: TSizes.sm,
              horizontal: TSizes.md,
            ),
            backgroundColor: THelperFunctions.getUnitContractStatusColor(
              user.contractStatus!,
            ).withOpacity(0.1),
            child: Text(
              THelperFunctions.getUnitContractStatusText(
                user.contractStatus!,
              ),
              style: TextStyle(
                color: THelperFunctions.getUnitStatusColor(
                  user.contractStatus!,
                ),
              ),
            ),
          ),
        ),

        DataCell(Text(user.createdAt == null ? '' : user.formattedDate)),
        DataCell(
          TTableActionButtons(
            view: true,
            edit: true,

            onViewPressed: () async {
              //  controller.tenantModel.value = tenant;

              final controllerContract = Get.put(PermissionController());

              controllerContract.initializeContractData(
                user.userContractId!,
              );

              //  controllerContract.contractModel.value;

              debugPrint('User FULL Name: ${user.fullName}');
              final result = await Get.toNamed(
                Routes.userDetails,
                arguments: user,
              );

              if (result == true) {
                final updatedUser = controller.userModel.value;
                final index = controller.filteredItems.indexWhere(
                  (t) => t.id == updatedUser.id,
                );
                if (index != -1) {
                  controller.filteredItems[index] = updatedUser ;
                  controller.filteredItems.refresh();
                }
              }
            },
            onEditPressed: () async {
              controller.userModel.value = user;

              final result = await showDialog<bool>(
                context: Get.context!,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return const EditUserDialog();
                },
              );

              if (result == true) {
                //  debugPrint('User updated successfully');
                controller.refreshData();
                // update the UI
                controller.userModel.refresh();
              } else {
                debugPrint('User update failed');
              }
            },
            onDeletePressed: () => controller.confirmAndDeleteItem(user),
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
