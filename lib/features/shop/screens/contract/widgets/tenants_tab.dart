import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:path/path.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/common/widgets/containers/rounded_container.dart';
import 'package:xm_frontend/common/widgets/images/t_circular_image.dart';
import 'package:xm_frontend/data/models/contract_model.dart';
import 'package:xm_frontend/features/personalization/models/user_model.dart';
import 'package:xm_frontend/features/shop/controllers/contract/contract_controller.dart';
import 'package:xm_frontend/features/shop/screens/contract/dialogs/create_contract.dart';
import 'package:xm_frontend/features/shop/screens/contract/dialogs/edit_contract.dart';
import 'package:xm_frontend/features/shop/screens/tenant/dialogs/create_tenant.dart';
import 'package:xm_frontend/features/shop/screens/tenant/dialogs/view_tenant.dart';
import 'package:xm_frontend/utils/constants/colors.dart';
import 'package:xm_frontend/utils/constants/enums.dart';
import 'package:xm_frontend/utils/constants/image_strings.dart';
import 'package:xm_frontend/utils/constants/sizes.dart';
import 'package:xm_frontend/utils/device/device_utility.dart';
import 'package:xm_frontend/utils/popups/loaders.dart';

class TenantsTab extends StatelessWidget {
  const TenantsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controllerContract = Get.find<ContractController>();

    controllerContract.loadTenants();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row for the search, button, and filter
          Row(
            mainAxisAlignment: MainAxisAlignment.end, // Align to the right
            children: [
              // TextField
              Expanded(
                flex: TDeviceUtils.isDesktopScreen(context) ? 2 : 1,
                child: TextFormField(
                  onChanged: (query) => controllerContract.filterTenants(query),
                  decoration: InputDecoration(
                    hintText: AppLocalization.of(
                      context,
                    ).translate('tenants_screen.lbl_search_tenants'),
                    prefixIcon: Icon(Iconsax.search_normal),
                  ),
                ),
              ),

              const SizedBox(width: TSizes.spaceBtwItems),
              // Button
              TextButton.icon(
                onPressed: () async {
                  final updatedContract = await showDialog<ContractModel>(
                    context: Get.context!,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return EditContractDialog(
                        contractId: int.parse(
                          controllerContract.contractModel.value.id!,
                        ),
                        isShowFullDetailsBtn: false,
                        isAddTenant: true,
                      );
                    },
                  );

                  if (updatedContract != null) {
                    controllerContract.contractModel.value.tenantCount =
                        updatedContract.tenantCount;
                    controllerContract.contractModel.value.tenantNames =
                        updatedContract.tenantNames;
                    controllerContract.contractModel.value.tenants =
                        updatedContract.tenants;

                    controllerContract.contractModel.refresh();
                    controllerContract.isDataUpdated.value = true;
                    controllerContract.loadingTenants.value = true;

                    controllerContract.loadTenants();
                  }
                },

                icon: const Icon(Icons.person_add, color: TColors.alterColor),
                label: Text(
                  style: TextStyle(color: TColors.alterColor),
                  AppLocalization.of(
                    context,
                  ).translate('dashboard_screen.lbl_add_tenant'),
                ),
              ),
            ],
          ),

          const SizedBox(height: TSizes.spaceBtwItems),

          // Use Obx to listen to loadingTenants state
          Obx(() {
            // Show loading indicator if tenants are still being fetched
            if (controllerContract.loadingTenants.value) {
              return Center(
                child: Column(
                  children: [
                    const SizedBox(height: TSizes.spaceBtwItems),
                    CircularProgressIndicator(color: TColors.primary),
                  ],
                ),
              );
            }

            // Show message if no tenants available
            if (controllerContract.filteredTenants.isEmpty) {
              return Center(
                child: Column(
                  children: [
                    const SizedBox(height: 100),

                    Text(
                      AppLocalization.of(
                        Get.context!,
                      ).translate('unit_detail_screen.lbl_no_tenants_found'),
                    ),
                  ],
                ),
              );
            }

            // If tenants are available, show the grid
            return Expanded(
              child: GridView.builder(
                itemCount: controllerContract.filteredTenants.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      TDeviceUtils.isDesktopScreen(context)
                          ? 3
                          : TDeviceUtils.isTabletScreen(context)
                          ? 2
                          : 1,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  mainAxisExtent: 100,
                ),
                itemBuilder: (context, index) {
                  final tenant = controllerContract.filteredTenants[index];
                  return _buildTenantCard(
                    tenant.displayName,
                    tenant.email,
                    tenant.profilePicture,
                    controllerContract,
                    tenant.isPrimaryTenant ?? 0,
                    tenant,
                    context,
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTenantCard(
    String tenantName,
    String tenantEmail,
    String tenantProfilePicture,
    ContractController controller,
    int isPrimaryTenant,
    UserModel tenant,
    BuildContext context,
  ) {
    return Container(
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: TSizes.spaceBtwItems),

          // Avatar
          TCircularImage(
            width: 60,
            height: 60,
            padding: 2,
            fit: BoxFit.cover,
            backgroundColor: TColors.primaryBackground,
            image:
                tenantProfilePicture.isNotEmpty
                    ? tenantProfilePicture
                    : TImages.user,
            imageType:
                tenantProfilePicture.isNotEmpty
                    ? ImageType.network
                    : ImageType.asset,
          ),

          const SizedBox(width: TSizes.spaceBtwItems),

          // Name, Email, and Primary label
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  tenantName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  tenantEmail,
                  style: const TextStyle(color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
                if (isPrimaryTenant == 1)
                  Text(
                    AppLocalization.of(
                      Get.context!,
                    ).translate('tenants_screen.lbl_primary_tenant'),
                    style: TextStyle(color: TColors.alterColor),
                  ),
              ],
            ),
          ),

          // Popup menu button
          Align(
            alignment: Alignment.center,
            child: PopupMenuButton<String>(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              offset: const Offset(0, 40),
              color: Colors.white,
              onSelected: (value) async {
                if (value == 'primary') {
                  final result = await controller.updateTenantContractPrimary(
                    int.parse(controller.contractModel.value.id!),
                    int.parse(tenant.id!),
                  );

                  if (result) {
                    controller.initializeContractData(
                      int.parse(controller.contractModel.value.id!),
                    );
                    controller.loadingTenants.value = true;
                    controller.isDataUpdated.value = true;

                    controller.loadTenants();
                  }
                } else if (value == 'view') {
                  final result = await showDialog<bool>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return ViewTenantDialog(
                        tenant: tenant,
                        contractCode: tenant.contractReference,
                      );
                    },
                  );
                } else if (value == 'remove') {
                  // remove tenant from contract

                  if (controller.contractModel.value.tenantCount! < 2) {
                    TLoaders.warningSnackBar(
                      title: AppLocalization.of(
                        Get.context!,
                      ).translate('general_msgs.msg_warning'),
                      message: AppLocalization.of(Get.context!).translate(
                        'unit_detail_screen.lbl_cannot_remove_last_tenant',
                      ),
                    );
                    return;
                  }

                  // Remove handler
                  final result = await controller.removeTenantFromContract(
                    int.parse(controller.contractModel.value.id!),
                    int.parse(tenant.id!),
                  );

                  if (result) {
                    await controller.initializeContractData(
                      int.parse(controller.contractModel.value.id!),
                    );

                    if (controller.contractModel.value.tenantCount == 1) {
                      // set to primary

                      controller.updateTenantContractPrimary(
                        int.parse(controller.contractModel.value.id!),
                        int.parse(
                          controller.contractModel.value.tenants![0].id!,
                        ),
                      );

                      tenant.isPrimaryTenant = 1;
                      // update the contract model
                      controller
                          .contractModel
                          .value
                          .tenants![0]
                          .isPrimaryTenant = 1;
                      controller.contractModel.value.tenantCount = 1;
                      controller.contractModel.refresh();
                    }
                    controller.loadingTenants.value = true;
                    controller.isDataUpdated.value = true;

                    controller.loadTenants();
                  }
                }
              },

              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: 'view',
                    child: Row(
                      children: [
                        const Icon(Icons.person, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalization.of(
                            Get.context!,
                          ).translate('general_msgs.msg_view_details'),
                        ),
                      ],
                    ),
                  ),
                  if (tenant.isPrimaryTenant == 0)
                    PopupMenuItem<String>(
                      value: 'primary',
                      child: Row(
                        children: [
                          const Icon(Icons.star, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            AppLocalization.of(Get.context!).translate(
                              'general_msgs.msg_set_as_primary_tenant',
                            ),
                          ),
                        ],
                      ),
                    ),
                  PopupMenuItem<String>(
                    value: 'remove',
                    child: Row(
                      children: [
                        const Icon(Icons.close, size: 20, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalization.of(
                            Get.context!,
                          ).translate('general_msgs.msg_remove'),
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ];
              },
              icon: const Icon(Icons.more_vert),
            ),
          ),
        ],
      ),
    );
  }
}
