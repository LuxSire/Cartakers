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
import 'package:xm_frontend/features/shop/screens/settings_managements/dialogs/edit_user.dart';
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

        debugPrint('User FULL Name: ${user.profilePicture}');
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
                      user.displayName,
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
        // 2. Company Name
        DataCell(Text(user.companyName ?? '')), // <-- Added cell for company name
        // 3. Email
        DataCell(Text(user.email)),
        // 4. Phone
        DataCell(Text(user.phoneNumber)),
        // 5. Role
        DataCell(Text(user.roleName ?? '')),
        // 6. Actions
        DataCell(
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                TTableActionButtons(
                  view: true,
                  edit: true,
                  sendUserInvitation: true,
                  onSendUserInvitationPressed: () async {
                    await controller.sendUserInvitation(user);
                    controller.refreshData();
                  },
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
                        return const EditUserDialog(showExtraFields: false);
                      },
                    );
                    if (result == true) {
                      controller.refreshData();
                      controller.userModel.refresh();
                       
                    } else {
                      debugPrint('User update failed');
                    }
                  },
                  onDeletePressed: () async {
                    await controller.confirmAndDeleteItem(user);
                    controller.refreshData();
                  },
                ),
              ],
            ),
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
