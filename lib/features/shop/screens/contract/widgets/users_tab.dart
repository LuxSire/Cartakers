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
import 'package:xm_frontend/features/shop/screens/user/dialogs/create_user.dart';
import 'package:xm_frontend/features/shop/screens/user/dialogs/view_user.dart';
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

    controllerContract.loadUsers();

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
                    ).translate('users_screen.lbl_search_users'),
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
                    controllerContract.contractModel.value.userCount =
                        updatedContract.userCount;
                    controllerContract.contractModel.value.userNames =
                        updatedContract.userNames;
                    controllerContract.contractModel.value.users =
                        updatedContract.users;

                    controllerContract.contractModel.refresh();
                    controllerContract.isDataUpdated.value = true;
                    controllerContract.loadingUsers.value = true;

                    controllerContract.loadUsers();
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
            // Show loading indicator if users are still being fetched
            if (controllerContract.loadingUsers.value) {
              return Center(
                child: Column(
                  children: [
                    const SizedBox(height: TSizes.spaceBtwItems),
                    CircularProgressIndicator(color: TColors.primary),
                  ],
                ),
              );
            }

            // Show message if no users available
            if (controllerContract.filteredUsers.isEmpty) {
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
                itemCount: controllerContract.filteredUsers.length,
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
                  final user = controllerContract.filteredUsers[index];
                  return _buildUserCard(
                    user.displayName,
                    user.email,
                    user.profilePicture,
                    controllerContract,
                    user.isPrimaryUser ?? 0,
                    user,
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

  Widget _buildUserCard(
    String userName,
    String userEmail,
    String userProfilePicture,
    ContractController controller,
    int isPrimaryUser,
    UserModel user,
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
                userProfilePicture.isNotEmpty
                    ? userProfilePicture
                    : TImages.user,
            imageType:
                userProfilePicture.isNotEmpty
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
                  userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  userEmail,
                  style: const TextStyle(color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
                if (isPrimaryUser == 1)
                  Text(
                    AppLocalization.of(
                      Get.context!,
                    ).translate('users_screen.lbl_primary_user'),
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
                  final result = await controller.updateUserContractPrimary(
                    int.parse(controller.contractModel.value.id!),
                    int.parse(user.id!),
                  );

                  if (result) {
                    controller.initializeContractData(
                      int.parse(controller.contractModel.value.id!),
                    );
                    controller.loadingUsers.value = true;
                    controller.isDataUpdated.value = true;

                    controller.loadUsers();
                  }
                } else if (value == 'view') {
                  final result = await showDialog<bool>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return ViewUserDialog(
                        user: user,
                        contractCode: user.contractReference,
                      );
                    },
                  );
                } else if (value == 'remove') {
                  // remove tenant from contract

                  if (controller.contractModel.value.userCount! < 2) {
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
                  final result = await controller.removeUserFromContract(
                    int.parse(controller.contractModel.value.id!),
                    int.parse(user.id!),
                  );

                  if (result) {
                    await controller.initializeContractData(
                      int.parse(controller.contractModel.value.id!),
                    );

                    if (controller.contractModel.value.userCount == 1) {
                      // set to primary

                      controller.updateUserContractPrimary(
                        int.parse(controller.contractModel.value.id!),
                        int.parse(
                          controller.contractModel.value.users![0].id!,
                        ),
                      );

                      user.isPrimaryUser = 1;
                      // update the contract model
                      controller
                          .contractModel
                          .value
                          .users![0]
                          .isPrimaryUser = 1;
                      controller.contractModel.value.userCount = 1;
                      controller.contractModel.refresh();
                    }
                    controller.loadingUsers.value = true;
                    controller.isDataUpdated.value = true;

                    controller.loadUsers();
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
                  if (user.isPrimaryUser == 0)
                    PopupMenuItem<String>(
                      value: 'primary',
                      child: Row(
                        children: [
                          const Icon(Icons.star, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            AppLocalization.of(Get.context!).translate(
                              'general_msgs.msg_set_as_primary_user',
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
