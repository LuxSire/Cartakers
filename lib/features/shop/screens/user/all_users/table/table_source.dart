import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
//import 'package:xm_frontend/common/widgets/containers/rounded_container.dart';
import 'package:xm_frontend/common/widgets/images/t_circular_image.dart';
//import 'package:xm_frontend/features/personalization/models/user_model.dart';
//import 'package:xm_frontend/features/shop/controllers/object/object_controller.dart';
//import 'package:xm_frontend/features/shop/controllers/object/edit_object_controller.dart';
//import 'package:xm_frontend/features/shop/controllers/contract/contract_controller.dart';
import 'package:xm_frontend/features/personalization/controllers/user_controller.dart';
import 'package:xm_frontend/features/shop/screens/user/dialogs/edit_user.dart';
import 'package:xm_frontend/routes/routes.dart';
import 'package:xm_frontend/utils/constants/image_strings.dart';
//import 'package:xm_frontend/utils/helpers/helper_functions.dart';

import '../../../../../../common/widgets/icons/table_action_icon_buttons.dart';
//import '../../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';

class UsersRows extends DataTableSource {
  final controller = Get.find<UserController>();

  // UsersRows  () {
  //   controller.refreshData();
  // }

  @override
  DataRow? getRow(int index) {
//    if (index >= controller.filteredUsers.length)
 //     return null; // prevent overflow

    final user = controller.filteredUsers[index];
    debugPrint("UsersRows initialized" 
        " for user: ${user.fullName} with index: $index");

    return DataRow2(
      onTap: () async {

        debugPrint('User FULL Name: ${user.fullName}');
        final result = await Get.toNamed(
          Routes.userDetails,
          arguments: user,
        );

        if (result == true) {
          final updatedUser = controller.user.value;
          final index = controller.filteredUsers.indexWhere(
            (t) => t.id == updatedUser.id,
          );
          if (index != -1) {
            controller.filteredUsers[index] = updatedUser;
            controller.filteredUsers.refresh();
          }
        }
      },
      selected: controller.selectedRows[index],
      onSelectChanged:
          (value) => controller.selectedRows[index] = value ?? false,
      cells: [
        // 1. User name (with image)
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
        // 2. Object Name
        DataCell(Text(user.objectName ?? '')), // <-- Added cell for object name
        // 3. Email
        DataCell(Text(user.email)),
        // 4. Phone
        DataCell(Text(user.fullPhoneNumber!)),
        // 5. Date Created
        DataCell(Text(user.createdAt == null ? '' : user.formattedDate)),
        // 6. Actions
        DataCell(
          TTableActionButtons(
            view: true,
            edit: true,
            onViewPressed: () async {
              debugPrint('User FULL Name: ${user.fullName}');
              final result = await Get.toNamed(
                Routes.userDetails,
                arguments: user,
              );
              if (result == true) {
                final updatedUser = controller.userModel.value;
                final index = controller.filteredUsers.indexWhere(
                  (t) => t.id == updatedUser.id,
                );
                if (index != -1) {
                  controller.filteredUsers[index] = updatedUser;
                  controller.filteredUsers.refresh();
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
                controller.refreshData();
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
  int get rowCount => controller.filteredUsers.length;

  @override
  int get selectedRowCount =>
      controller.selectedRows.where((selected) => selected).length;
}
