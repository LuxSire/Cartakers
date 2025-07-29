import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/common/widgets/containers/rounded_container.dart';
import 'package:xm_frontend/common/widgets/images/t_circular_image.dart';
import 'package:xm_frontend/features/personalization/models/user_model.dart';
import 'package:xm_frontend/features/shop/controllers/building/building_controller.dart';
import 'package:xm_frontend/features/shop/controllers/building/edit_building_controller.dart';
import 'package:xm_frontend/features/shop/controllers/contract/contract_controller.dart';
import 'package:xm_frontend/features/shop/controllers/tenant/tenant_controller.dart';
import 'package:xm_frontend/features/shop/screens/tenant/dialogs/edit_tenant.dart';
import 'package:xm_frontend/routes/routes.dart';
import 'package:xm_frontend/utils/constants/image_strings.dart';
import 'package:xm_frontend/utils/helpers/helper_functions.dart';

import '../../../../../../common/widgets/icons/table_action_icon_buttons.dart';
import '../../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';

class TenantsRows extends DataTableSource {
  final controller = TenantController.instance;

  // TenantsRows() {
  //   controller.refreshData();
  // }

  @override
  DataRow? getRow(int index) {
    if (index >= controller.filteredItems.length)
      return null; // prevent overflow

    final tenant = controller.filteredItems[index];
    return DataRow2(
      onTap: () async {
        final controllerContract = Get.put(ContractController());

        controllerContract.initializeContractData(tenant.tenantContractId!);

        //  controllerContract.contractModel.value;

        debugPrint('Tenant FULL Name: ${tenant.fullName}');
        final result = await Get.toNamed(
          Routes.tenantDetails,
          arguments: tenant,
        );

        if (result == true) {
          final updatedTenant = controller.tenantModel.value;
          final index = controller.filteredItems.indexWhere(
            (t) => t.id == updatedTenant.id,
          );
          if (index != -1) {
            controller.filteredItems[index] = updatedTenant;
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
                    tenant.profilePicture.isNotEmpty
                        ? tenant.profilePicture
                        : TImages.user,
                imageType:
                    tenant.profilePicture.isNotEmpty
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
                      tenant.fullName,

                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (tenant.isPrimaryTenant == 1) ...[
                      Text(
                        AppLocalization.of(
                          Get.context!,
                        ).translate('tenants_screen.lbl_primary_tenant'),
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
        DataCell(Text(tenant.buildingName!)),
        DataCell(Text(tenant.email)),
        DataCell(Text(tenant.fullPhoneNumber!)),
        DataCell(Text(tenant.unitNumber!)),
        DataCell(Text(tenant.contractReference!)),
        DataCell(
          TRoundedContainer(
            radius: TSizes.cardRadiusSm,
            padding: const EdgeInsets.symmetric(
              vertical: TSizes.sm,
              horizontal: TSizes.md,
            ),
            backgroundColor: THelperFunctions.getUnitContractStatusColor(
              tenant.contractStatus!,
            ).withOpacity(0.1),
            child: Text(
              THelperFunctions.getUnitContractStatusText(
                tenant.contractStatus!,
              ),
              style: TextStyle(
                color: THelperFunctions.getUnitStatusColor(
                  tenant.contractStatus!,
                ),
              ),
            ),
          ),
        ),

        DataCell(Text(tenant.createdAt == null ? '' : tenant.formattedDate)),
        DataCell(
          TTableActionButtons(
            view: true,
            edit: true,

            onViewPressed: () async {
              //  controller.tenantModel.value = tenant;

              final controllerContract = Get.put(ContractController());

              controllerContract.initializeContractData(
                tenant.tenantContractId!,
              );

              //  controllerContract.contractModel.value;

              debugPrint('Tenant FULL Name: ${tenant.fullName}');
              final result = await Get.toNamed(
                Routes.tenantDetails,
                arguments: tenant,
              );

              if (result == true) {
                final updatedTenant = controller.tenantModel.value;
                final index = controller.filteredItems.indexWhere(
                  (t) => t.id == updatedTenant.id,
                );
                if (index != -1) {
                  controller.filteredItems[index] = updatedTenant;
                  controller.filteredItems.refresh();
                }
              }
            },
            onEditPressed: () async {
              controller.tenantModel.value = tenant;

              final result = await showDialog<bool>(
                context: Get.context!,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return const EditTenantDialog();
                },
              );

              if (result == true) {
                //  debugPrint('Tenant updated successfully');
                controller.refreshData();
                // update the UI
                controller.tenantModel.refresh();
              } else {
                debugPrint('Tenant update failed');
              }
            },
            onDeletePressed: () => controller.confirmAndDeleteItem(tenant),
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
