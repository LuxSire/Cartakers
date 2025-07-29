import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/data/repositories/authentication/authentication_repository.dart';
import 'package:xm_frontend/features/personalization/controllers/settings_controller.dart';
import 'package:xm_frontend/utils/constants/enums.dart';

import '../../../../routes/routes.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../images/t_circular_image.dart';
import 'menu/menu_item.dart';

/// Sidebar widget for navigation menu
class TSidebar extends StatelessWidget {
  const TSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const BeveledRectangleBorder(),
      child: Container(
        decoration: const BoxDecoration(
          color: TColors.white,
          border: Border(right: BorderSide(width: 1, color: TColors.grey)),
        ),
        child: Stack(
          children: [
            //  Main Sidebar Content (Scrollable)
            Positioned.fill(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // App Logo + Agency Name
                    Padding(
                      padding: const EdgeInsets.all(TSizes.sm),
                      child: Row(
                        children: [
                          TCircularImage(
                            width: 50,
                            height: 50,
                            padding: 0,
                            margin: TSizes.sm,
                            backgroundColor: Colors.transparent,
                            imageType:
                                SettingsController
                                        .instance
                                        .settings
                                        .value
                                        .appLogo
                                        .isNotEmpty
                                    ? ImageType.network
                                    : ImageType.asset,
                            image:
                                SettingsController
                                        .instance
                                        .settings
                                        .value
                                        .appLogo
                                        .isNotEmpty
                                    ? SettingsController
                                        .instance
                                        .settings
                                        .value
                                        .appLogo
                                    : TImages.lightAppLogo,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  SettingsController
                                      .instance
                                      .settings
                                      .value
                                      .appName,
                                  style:
                                      Theme.of(context).textTheme.headlineLarge,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  AuthenticationRepository
                                      .instance
                                      .currentUser!
                                      .agencyName,
                                  style: Theme.of(context).textTheme.bodySmall,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: TSizes.spaceBtwSections),

                    // Menu Items (Scrollable)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TSizes.md,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TMenuItem(
                            route: Routes.dashboard,
                            icon: Iconsax.category,
                            itemName: AppLocalization.of(
                              context,
                            ).translate('sidebar.lbl_dashboard'),
                          ),
                          TMenuItem(
                            route: Routes.buildingsUnits,
                            icon: Iconsax.building,
                            itemName: AppLocalization.of(
                              context,
                            ).translate('buildings_screen.lbl_buildings'),
                          ),
                          TMenuItem(
                            route: Routes.tenantsContracts,
                            icon: Iconsax.profile_2user,
                            itemName: AppLocalization.of(
                              context,
                            ).translate('sidebar.lbl_tenants_and_contracts'),
                          ),
                          TMenuItem(
                            route: Routes.bookingsRequests,
                            icon: Iconsax.calendar_search,
                            itemName: AppLocalization.of(
                              context,
                            ).translate('sidebar.lbl_bookings_and_requests'),
                          ),

                          // TMenuItem(
                          //   route: Routes.tasks,
                          //   icon: Iconsax.clipboard_text,
                          //   itemName: AppLocalization.of(
                          //     context,
                          //   ).translate('sidebar.lbl_tasks'),
                          // ),
                          TMenuItem(
                            route: Routes.communication,
                            icon: Iconsax.direct,
                            itemName: AppLocalization.of(
                              context,
                            ).translate('sidebar.lbl_communication'),
                          ),
                          TMenuItem(
                            route: Routes.settingsManagement,
                            icon: Iconsax.setting,
                            itemName: AppLocalization.of(
                              context,
                            ).translate('sidebar.lbl_settings_and_management'),
                          ),
                          TMenuItem(
                            route: 'logout',
                            icon: Iconsax.logout,
                            itemName: AppLocalization.of(
                              context,
                            ).translate('sidebar.lbl_logout'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Fixed Version at Bottom
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    'v.1.0.4', //  App Version
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: TColors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
