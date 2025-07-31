import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/common/widgets/images/t_circular_image.dart';
import 'package:xm_frontend/data/api/translation_api.dart';
import 'package:xm_frontend/data/repositories/authentication/authentication_repository.dart';
import 'package:xm_frontend/features/personalization/controllers/user_controller.dart';
import 'package:xm_frontend/features/shop/screens/settings_managements/dialogs/edit_user.dart';
import 'package:xm_frontend/utils/constants/colors.dart';
import 'package:xm_frontend/utils/constants/enums.dart';
import 'package:xm_frontend/utils/constants/image_strings.dart';
import 'package:xm_frontend/utils/constants/sizes.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();

    // add post frame callback to ensure the controller is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userController.user.value.id == null) {
        userController.fetchUserDetails();
      }
    });

    return Padding(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Obx(() {
        final user = userController.user.value;

        return ListView(
          children: [
            // ── Header Card ───────────────────────────────
            Card(
              color: TColors.softGrey.withOpacity(1),
              elevation: 0.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: Row(
                  children: [
                    // Avatar
                    TCircularImage(
                      width: 80,
                      height: 80,
                      padding: 2,
                      fit: BoxFit.cover,
                      backgroundColor: TColors.primary.withOpacity(0.1),
                      image:
                          user.profilePicture.isNotEmpty
                              ? user.profilePicture
                              : TImages.user,
                      imageType:
                          user.profilePicture.isNotEmpty
                              ? ImageType.network
                              : ImageType.asset,
                    ),

                    const SizedBox(width: TSizes.defaultSpace),

                    // Name & Role
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${user.firstName ?? ''} ${user.lastName ?? ''}',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 4),

                          // change the text to futurebuilder
                          FutureBuilder<String?>(
                            future: TranslationApi.smartTranslate(
                              user.roleNameExt ?? '',
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return Text(
                                  snapshot.data ?? '',
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),

                    // Edit button
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        backgroundColor: TColors.primary.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        final userId =
                            AuthenticationRepository.instance.currentUser?.id!;
                        final controller = Get.find<UserController>();

                        controller.resetUserDetails();

                        // Fetch the user BEFORE opening the dialog
                        await controller.fetchUserDetailsById(
                          int.parse(userId!),
                        );

                        controller.loadAllObjects();
                        controller.loadAllUserRoles();

                        await showDialog(
                          context: context,
                          builder:
                              (context) =>
                                  EditUserDialog(showExtraFields: false),
                        );
                      },

                      icon: const Icon(Iconsax.edit, color: TColors.primary),
                      label: Text(
                        AppLocalization.of(
                          context,
                        ).translate('general_msgs.msg_edit'),
                        style: const TextStyle(color: TColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // ── Details Card ──────────────
            Card(
              color: TColors.softGrey.withOpacity(1),
              elevation: 0.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      AppLocalization.of(
                        context,
                      ).translate('tab_settings_screen.lbl_profile'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Divider(height: TSizes.spaceBtwSections),

                    // Two-column grid of info rows
                    Wrap(
                      spacing: TSizes.defaultSpace,
                      runSpacing: TSizes.defaultSpace,
                      children: [
                        _InfoItem(
                          label: AppLocalization.of(
                            context,
                          ).translate('tenants_screen.lbl_first_name'),
                          value: user.firstName ?? '',
                        ),
                        _InfoItem(
                          label: AppLocalization.of(
                            context,
                          ).translate('tenants_screen.lbl_last_name'),
                          value: user.lastName ?? '',
                        ),
                        if (user.fullPhoneNumber?.isNotEmpty ?? false)
                          _InfoItem(
                            label: AppLocalization.of(
                              context,
                            ).translate('tenants_screen.lbl_phone_no'),
                            value: user.fullPhoneNumber ?? '',
                          ),
                        _InfoItem(
                          label: AppLocalization.of(
                            context,
                          ).translate('tenants_screen.lbl_email'),
                          value: user.email ?? '',
                        ),
                        if ((user.lang ?? '').isNotEmpty)
                          _InfoItem(
                            label: AppLocalization.of(context).translate(
                              'tenants_screen.lbl_preferred_language',
                            ),
                            value: user.lang!,
                            icon: Iconsax.language_circle5,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

/// A small widget to display one “label → value” pair
class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;

  const _InfoItem({
    Key? key,
    required this.label,
    required this.value,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Constrain each item to roughly half the width
    final maxWidth =
        (MediaQuery.of(context).size.width - 3 * TSizes.defaultSpace) / 2;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              if (icon != null) ...[
                const SizedBox(width: 4),
                Icon(icon, size: 18, color: TColors.primary),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
