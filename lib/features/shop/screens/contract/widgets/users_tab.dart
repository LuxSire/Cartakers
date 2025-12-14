import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:path/path.dart';
import 'package:cartakers/app/localization/app_localization.dart';
import 'package:cartakers/common/widgets/containers/rounded_container.dart';
import 'package:cartakers/common/widgets/images/t_circular_image.dart';
import 'package:cartakers/data/models/permission_model.dart';
import 'package:cartakers/features/personalization/models/user_model.dart';
import 'package:cartakers/features/shop/controllers/contract/permission_controller.dart';
import 'package:cartakers/features/shop/screens/contract/dialogs/create_contract.dart';
import 'package:cartakers/features/shop/screens/contract/dialogs/edit_contract.dart';
import 'package:cartakers/features/shop/screens/user/dialogs/create_user.dart';
import 'package:cartakers/features/shop/screens/user/dialogs/view_user.dart';
import 'package:cartakers/utils/constants/colors.dart';
import 'package:cartakers/utils/constants/enums.dart';
import 'package:cartakers/utils/constants/image_strings.dart';
import 'package:cartakers/utils/constants/sizes.dart';
import 'package:cartakers/utils/device/device_utility.dart';
import 'package:cartakers/utils/popups/loaders.dart';

class UsersTab extends StatelessWidget {
  const UsersTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controllerContract = Get.find<PermissionController>();

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
                  onChanged: (query) => controllerContract.filterUsers(query),
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
                  final updatedContract = await showDialog<PermissionModel>(
                    context: Get.context!,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return EditContractDialog(
                        contractId: int.parse(
                          controllerContract.permissionModel.value.id!,
                        ),
                        isShowFullDetailsBtn: false,
                        isAddTenant: true,
                      );
                    },
                  );

                  if (updatedContract != null) {
                    controllerContract.permissionModel.value.users =
                        updatedContract.users;

                    controllerContract.permissionModel.refresh();
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
                  ).translate('dashboard_screen.lbl_add_user'),
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
                      ).translate('unit_detail_screen.lbl_no_users_found'),
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
    PermissionController controller,
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

        ],
      ),
    );
  }
}
