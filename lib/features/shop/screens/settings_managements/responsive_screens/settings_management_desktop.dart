import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:xm_frontend/common/widgets/loaders/loader_animation.dart';
import 'package:xm_frontend/features/personalization/controllers/user_controller.dart';
//import 'package:xm_frontend/features/shop/controllers/user/user_controller.dart';
import 'package:xm_frontend/features/shop/screens/settings_managements/widgets/settings_management_detail_tab.dart';
//import 'package:xm_frontend/features/shop/screens/users_permissions/widgets/users_permissions_detail_tab.dart';
import 'package:xm_frontend/utils/constants/colors.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';

class SettingsManagementDesktopScreen extends StatelessWidget {
  const SettingsManagementDesktopScreen({super.key, required this.roleExtId});
  final int roleExtId;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserController>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Breadcrumbs
            TBreadcrumbsWithHeading(
              heading: AppLocalization.of(
                context,
              ).translate('sidebar.lbl_settings_and_management'),
              breadcrumbItems: const [],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Main content
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) return const TLoaderAnimation();

                return TRoundedContainer(
                  child:
                      roleExtId == 1
                          ? DefaultTabController(
                            length: 2,
                            child: Column(
                              children: [
                                // TabBar with left alignment
                                TabBar(
                                  tabAlignment: TabAlignment.start,
                                  isScrollable: true,
                                  indicatorColor: TColors.alterColor,
                                  labelColor: TColors.alterColor,
                                  indicatorWeight: 1,
                                  unselectedLabelColor: Colors.black
                                      .withOpacity(0.6),
                                  tabs: [
                                    Tab(
                                      text: AppLocalization.of(
                                        context,
                                      ).translate(
                                        'tab_settings_screen.lbl_settings',
                                      ),
                                      icon: const Icon(Iconsax.setting_2),
                                    ),
                                    Tab(
                                      text: AppLocalization.of(
                                        context,
                                      ).translate(
                                        'tab_management_screen.lbl_management',
                                      ),
                                      icon: const Icon(Iconsax.setting),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: TSizes.defaultSpace),
                                // Tab content
                                Expanded(
                                  child: TabBarView(
                                    children: [
                                      SettingsManagementDetailsTab(
                                        tabType: 'settings',
                                      ),
                                      SettingsManagementDetailsTab(
                                        tabType: 'management',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                          : DefaultTabController(
                            length: 1,
                            child: Column(
                              children: [
                                // TabBar with left alignment
                                TabBar(
                                  tabAlignment: TabAlignment.start,
                                  isScrollable: true,
                                  indicatorColor: TColors.alterColor,
                                  labelColor: TColors.alterColor,
                                  indicatorWeight: 1,
                                  unselectedLabelColor: Colors.black
                                      .withOpacity(0.6),
                                  tabs: [
                                    Tab(
                                      text: AppLocalization.of(
                                        context,
                                      ).translate(
                                        'tab_settings_screen.lbl_settings',
                                      ),
                                      icon: const Icon(Iconsax.setting_2),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: TSizes.defaultSpace),
                                // Tab content
                                Expanded(
                                  child: TabBarView(
                                    children: [
                                      SettingsManagementDetailsTab(
                                        tabType: 'settings',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
