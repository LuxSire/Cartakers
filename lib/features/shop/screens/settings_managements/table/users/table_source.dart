import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/common/widgets/containers/rounded_container.dart';
import 'package:xm_frontend/common/widgets/images/t_circular_image.dart';
import 'package:xm_frontend/features/personalization/controllers/user_controller.dart';
import 'package:xm_frontend/features/personalization/models/user_model.dart';
import 'package:xm_frontend/features/shop/controllers/contract/permission_controller.dart';
//import 'package:xm_frontend/features/shop/controllers/user/user_controller.dart';
import 'package:xm_frontend/features/shop/controllers/object/object_controller.dart';
import 'package:xm_frontend/features/shop/screens/settings_managements/dialogs/edit_user.dart';
//import 'package:xm_frontend/features/shop/screens/user/dialogs/edit_user.dart';
import 'package:xm_frontend/routes/routes.dart';
import 'package:xm_frontend/utils/constants/image_strings.dart';
import 'package:xm_frontend/utils/helpers/helper_functions.dart';

import '../../../../../../common/widgets/icons/table_action_icon_buttons.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';

class UserRows extends DataTableSource {
  final controller = UserController.instance;

  @override
  DataRow? getRow(int index) {
    if (controller.selectedRows.length != controller.filteredItems.length) {
      print(
        "selectedRows.length (${controller.selectedRows.length}) != filteredItems.length (${controller.filteredItems.length})",
      );
      return null;
    }
    if (index >= controller.filteredItems.length) {
      return null;
    }
    var user=controller.filteredItems[index];
      return DataRow2(
        onTap: () async {
          final userId = user.id.toString();
        final controller = Get.find<UserController>();
        final objectController = Get.find<ObjectController>();
        // reset the values before fetching
        controller.resetUserDetails();

        // Fetch the user BEFORE opening the dialog
        await controller.fetchUserDetailsById(int.parse(userId));

        objectController.loadAllObjects();
        controller.loadAllUserRoles();

        // await showDialog(
        //   context: Get.context!,
        //   builder: (context) => EditUserDialog(showExtraFields: true),
        // );
        controller.userModel.value = user;
        final updatedUser = await showDialog<UserModel>(
          context: Get.context!,
          barrierDismissible: false,
          builder: (_) => EditUserDialog(showExtraFields: true),
        );

        // debugPrint('Updated User in table: ${updatedUser?.toJson()}');

        if (updatedUser != null) {
          // Update the user in the filteredItems list

          final index = controller.filteredItems.indexWhere(
            (u) => u.id == updatedUser.id,
          );
          if (index != -1) {
            controller.filteredItems[index] = updatedUser;
            controller.filteredItems.refresh();

            controller.refreshData();
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
                  ],
                ),
              ),
            ],
          ),
        ),
        DataCell(Text(user.email!)),
        DataCell(Text(user.phoneNumber.toString())),
        DataCell(
          Text(
            user.objectPermissions == 'All'
                ? AppLocalization.of(
              Get.context!,
            ).translate('general_msgs.msg_all')
                : user.objectPermissions.toString(),
          ),
        ),

        DataCell(
          TRoundedContainer(
            radius: TSizes.cardRadiusSm,
            padding: const EdgeInsets.symmetric(
              vertical: TSizes.sm,
              horizontal: TSizes.md,
            ),
            backgroundColor: THelperFunctions.getUserStatusColor(
              user.statusId!,
            ).withOpacity(0.1),
            child: Text(
              user.translatedStatus.toString(),
              style: TextStyle(
                color: THelperFunctions.getUserStatusColor(user.statusId!),
              ),
            ),
          ),
        ),

        DataCell(Text(user.createdAt == null ? '' : user.formattedDate)),
        DataCell( SizedBox(
              width: 180, // Adjust this value as needed for your icons
              child: TTableActionButtons(
            view: false,
            edit: true,
            sendUserInvitation: true,
            

            onSendUserInvitationPressed:
                () => controller.sendUserInvitation(user),

            onViewPressed: () async {},
            onEditPressed: () async {
              final userId = user.id.toString();
              final controller = Get.find<UserController>();
              final objectController = Get.find<ObjectController>();
              // reset the values before fetching
              controller.resetUserDetails();

              // Fetch the user BEFORE opening the dialog
              await controller.fetchUserDetailsById(int.parse(userId));

              objectController.loadAllObjects();
              controller.loadAllUserRoles();

              // await showDialog(
              //   context: Get.context!,
              //   builder: (context) => EditUserDialog(showExtraFields: true),
              // );
              controller.userModel.value = user;
              final updatedUser = await showDialog<UserModel>(
                context: Get.context!,
                barrierDismissible: false,
                builder: (_) => EditUserDialog(showExtraFields: true),
              );

              // debugPrint('Updated User in table: ${updatedUser?.toJson()}');

              if (updatedUser != null) {
                final index = controller.filteredItems.indexWhere(
                  (r) => r.id == user.id,
                );

                //   debugPrint('Index of updated user: ${index}');
                // Update the user in the filteredItems list

                if (index != -1) {
                  controller.filteredItems[index] = updatedUser;
                  controller.filteredItems.refresh();

                  controller.refreshData();
                }
              }
            },
            onDeletePressed: () => controller.confirmAndDeleteItem(user),
          ),
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
