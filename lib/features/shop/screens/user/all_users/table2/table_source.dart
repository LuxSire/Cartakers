import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cartakers/app/localization/app_localization.dart';
import 'package:cartakers/common/widgets/containers/rounded_container.dart';
import 'package:cartakers/common/widgets/icons/table_action_icon_buttons.dart';
import 'package:cartakers/features/personalization/models/user_model.dart';
import 'package:cartakers/features/shop/controllers/contract/permission_controller.dart';
//import 'package:cartakers/features/shop/controllers/user/user_controller.dart';
import 'package:cartakers/features/shop/controllers/user/user_invitation_controller.dart';
//import 'package:cartakers/features/shop/screens/user/dialogs/dep_edit_user.dart';
import 'package:cartakers/routes/routes.dart';
import 'package:cartakers/utils/constants/colors.dart';
import 'package:cartakers/utils/constants/sizes.dart';
import 'package:cartakers/utils/helpers/helper_functions.dart';

class UsersInvitationRows extends DataTableSource {
  final controller = UserInvitationController.instance;

  @override
  DataRow? getRow(int index) {
    // Use only invitation-eligible users
    if (index >= controller.filteredItems.length) return null;
    final user = controller.filteredItems[index];

    return DataRow2(
      onTap: () async {},
      selected: controller.selectedRows[index],
      onSelectChanged:
          (value) => controller.selectedRows[index] = value ?? false,
      cells: [
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                user.fullName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (user.isPrimaryUser == 1)
                Text(
                  AppLocalization.of(
                    Get.context!,
                  ).translate('users_screen.lbl_primary_user'),
                  style: const TextStyle(
                    color: TColors.alterColor,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ),
        DataCell(Text(user.objectName ?? '')),
        DataCell(Text(user.email)),
        DataCell(Text(user.contractReference ?? '')),
        DataCell(
          TRoundedContainer(
            radius: TSizes.cardRadiusSm,
            padding: const EdgeInsets.symmetric(
              vertical: TSizes.sm,
              horizontal: TSizes.md,
            ),
            backgroundColor: THelperFunctions.getUserStatusColor(
              user.statusId ?? 0,
            ).withOpacity(0.1),
            child: Text(
              THelperFunctions.getUserStatusText(user.statusId ?? 0),
              style: TextStyle(
                color: THelperFunctions.getUserStatusColor(
                  user.statusId ?? 0,
                ),
              ),
            ),
          ),
        ),
        DataCell(
          Text(user.updatedAt == null ? '' : user.formattedUpdatedAtDate),
        ),
        DataCell(
          TTableActionButtons(
            view: false,
            edit: false,
            delete: false,
            sendUserInvitation: true,
            onSendUserInvitationPressed: () async {
              await controller.sendUserInvitation(user);
              controller.refreshData();
              // update the UI
              controller.userModel.refresh();
            },
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
