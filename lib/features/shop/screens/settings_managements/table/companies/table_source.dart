import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cartakers/app/localization/app_localization.dart';
import 'package:cartakers/common/widgets/containers/rounded_container.dart';
import 'package:cartakers/common/widgets/images/t_circular_image.dart';
import 'package:cartakers/features/personalization/controllers/user_controller.dart';
import 'package:cartakers/features/personalization/models/company_model.dart';
import 'package:cartakers/features/shop/controllers/contract/permission_controller.dart';
//import 'package:xm_frontend/features/shop/controllers/user/user_controller.dart';
import 'package:cartakers/features/shop/screens/settings_managements/dialogs/edit_company.dart';
//import 'package:xm_frontend/features/shop/screens/user/dialogs/edit_user.dart';
import 'package:cartakers/routes/routes.dart';
import 'package:cartakers/utils/constants/image_strings.dart';
import 'package:cartakers/utils/helpers/helper_functions.dart';
import 'package:cartakers/features/personalization/controllers/company_controller.dart';
import '../../../../../../common/widgets/icons/table_action_icon_buttons.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';

class CompanyRows extends DataTableSource {
  final u_controller = UserController.instance;
  final controller = Get.find<CompanyController>();

  @override
  DataRow? getRow(int index) {
    print('getRow called with index: $index');
    print('filteredItems.length: ${controller.filteredItems.length}');
    print('selectedRows.length: ${controller.selectedRows.length}');
    if (controller.selectedRows.length != controller.filteredItems.length) {
      print(
        "selectedRows.length (${controller.selectedRows.length}) != filteredItems.length (${controller.filteredItems.length})",
      );
      return null;
    }

    var company = controller.filteredItems[index];
    return DataRow2(
      onTap: () async {
        final companyId = company.id.toString();
        final controller = Get.find<CompanyController>();

        // reset the values before fetching
        //controller.resetCompany Details();

        // Fetch the company BEFORE opening the dialog
        await controller.fetchCompanyDetailsById(int.parse(companyId));

        

        // await showDialog(
        //   context: Get.context!,
        //   builder: (context) => EditUserDialog(showExtraFields: true),
        // );

        final updatedCompany = await showDialog<CompanyModel>(
          context: Get.context!,
          barrierDismissible: false,
          builder: (_) => EditCompanyDialog(showExtraFields: true),
        );

        // debugPrint('Updated User in table: ${updatedUser?.toJson()}');

        if (updatedCompany != null) {
          // Update the user in the filteredItems list

          final index = controller.filteredItems.indexWhere(
            (u) => u.id == updatedCompany.id,
          );
          if (index != -1) {
            controller.filteredItems[index] = updatedCompany;
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
                    company.profilePicture.isNotEmpty
                        ? company.profilePicture
                        : TImages.user,
                imageType:
                    company.profilePicture.isNotEmpty
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
                      company.fullName,

                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        DataCell(Text(company.email!)),
        DataCell(Text(company.phone.toString())),
       

        DataCell(
          TRoundedContainer(
            radius: TSizes.cardRadiusSm,
            padding: const EdgeInsets.symmetric(
              vertical: TSizes.sm,
              horizontal: TSizes.md,
            ),
            backgroundColor: THelperFunctions.getUserStatusColor(
              company.statusId!,
            ).withOpacity(0.1),
            child: Text(
              company.translatedStatus.toString(),
              style: TextStyle(
                color: THelperFunctions.getUserStatusColor(company.statusId!),
              ),
            ),
          ),
        ),

        DataCell(Text(company.createdAt == null ? '' : company.formattedDate)),
        DataCell( SizedBox(
              width: 180, // Adjust this value as needed for your icons
              child: TTableActionButtons(
            view: false,
            edit: true,
            delete:true,
            sendUserInvitation: true,
            

            onViewPressed: () async {},
            onEditPressed: () async {
              final companyId = company.id.toString();
              final controller = Get.find<CompanyController>();

              // reset the values before fetching
              //controller.resetUserDetails();

              // Fetch the user BEFORE opening the dialog
             

              controller.loadAllObjects();
             // controller.loadAllUserRoles();

              // await showDialog(
              //   context: Get.context!,
              //   builder: (context) => EditUserDialog(showExtraFields: true),
              // );
              controller.companyModel.value = company; // or whatever Rx<CompanyModel> you use
            await controller.fetchCompanyDetailsById(int.parse(companyId));
              final updatedCompany = await showDialog<CompanyModel>(
                context: Get.context!,
                barrierDismissible: false,
                builder: (_) => EditCompanyDialog(showExtraFields: true),
              );

              // debugPrint('Updated User in table: ${updatedUser?.toJson()}');

              if (updatedCompany != null) {
                final index = controller.filteredItems.indexWhere(
                  (r) => r.id == company.id,
                );

                //   debugPrint('Index of updated user: ${index}');
                // Update the user in the filteredItems list

                if (index != -1) {
                  controller.filteredItems[index] = updatedCompany;
                  controller.filteredItems.refresh();

                  controller.refreshData();
                }
              }
            },
            onDeletePressed: () => controller.deleteItem(company),
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
