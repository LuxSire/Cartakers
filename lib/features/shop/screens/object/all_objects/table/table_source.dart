import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/features/shop/controllers/object/object_controller.dart';
import 'package:xm_frontend/features/shop/controllers/object/edit_object_controller.dart';
import 'package:xm_frontend/routes/routes.dart';
//import 'package:xm_frontend/features/shop/controllers/user/user_controller.dart';
import '../../../../../../common/widgets/icons/table_action_icon_buttons.dart';
import '../../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';
import 'package:xm_frontend/features/personalization/controllers/user_controller.dart';
import 'package:xm_frontend/features/shop/controllers/contract/permission_controller.dart';
import 'package:xm_frontend/data/repositories/authentication/authentication_repository.dart';
import 'package:xm_frontend/features/shop/screens/communication/all_communications/dialogs/create_new_message.dart';
import 'package:xm_frontend/features/shop/screens/contract/dialogs/assign_request_dialog.dart';
import 'package:intl/intl.dart';

class ObjectRows extends DataTableSource {
  final controller = ObjectController.instance;
  final u_controller = UserController.instance;
  final p_controller = PermissionController.instance;
  final auth_controller = AuthenticationRepository.instance;
  @override
  DataRow? getRow(int index) {
    final object = controller.filteredItems[index];
    final usermodel = auth_controller.currentUser;
    final user_id = int.tryParse(usermodel?.id ?? '');
    bool allowed=true;
    return DataRow2(
      onTap: () {
        debugPrint('Tapped on object: ${object.name} for user: ${user_id ?? 0}');
        if (usermodel == null) {
          allowed = false;
          Get.snackbar(
            'Access Denied',
            'You do not have permission to access this object. Not yet. Make a request',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: TColors.error.withOpacity(0.1),
            colorText: TColors.error,
          );
          return;
        }
        if (p_controller.CheckObjectForUserModel(usermodel, object.id ?? 0)) {
          Get.toNamed(Routes.editObject, arguments: object)?.then((result) {
            if (result == true) {
              controller.refreshData(); // Force re-fetch on return
            }
          });
        } else {
          showDialog(
            context: Get.context!,
            builder: (context) => CreateMessageDialog(
              object: object,
              subject: 'Request Access to ${object.name}',
              message: 'Please give me access to ${object.name}',
            ),
            //builder: (context) => AssignRequestDialog(object: object),
          );

          Get.snackbar(
            'Access Denied',
            'You do not have permission to access this object. Not yet. Make a request',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: TColors.error.withOpacity(0.1),
            colorText: TColors.error,
          );
        }
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
               // backgroundColor: TColors.primaryBackground,
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
//        DataCell(Text(object.street ?? '')),
DataCell(Text(object.state?.toString() ?? object.city?.toString() ?? '')),
//DataCell(Text(object.zipCode ?? '')),
DataCell(Text(object.country ?? '')),
DataCell(Text(object.type_?.toString() ?? '')),
DataCell(Text(object.zoning?.toString() ?? '')),
DataCell(
  Text(
    object.price != null
      ? '${object.currency ?? ''} ${NumberFormat('#,##0', 'en_US').format(object.price)}'

      : '',
  ),
),
        DataCell(
          TTableActionButtons(
            view: true,
            edit: false,
            onViewPressed: () {

          if (p_controller.CheckObjectForUser(user_id ?? 0,object.id ?? 0))
            Get.toNamed(Routes.editObject, arguments: object)?.then((result) {
              if (result == true) {
                controller.refreshData(); // Force re-fetch on return
              }
            });
            else
            {
              showDialog(
                context: Get.context!,
                builder: (context) => CreateMessageDialog(object: object),
                //builder: (context) => AssignRequestDialog(),
              );

              Get.snackbar(
                'Access Denied',
                'You do not have permission to access this object. Not yet. Make a request',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: TColors.error.withOpacity(0.1),
                colorText: TColors.error,
              );
            }            },

            onDeletePressed: () => controller.deleteItem(object),
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
