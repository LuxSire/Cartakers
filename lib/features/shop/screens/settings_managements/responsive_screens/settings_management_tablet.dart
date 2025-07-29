import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/features/personalization/controllers/user_controller.dart';
import 'package:xm_frontend/features/shop/controllers/tenant/tenant_controller.dart';
import 'package:xm_frontend/features/shop/screens/settings_managements/widgets/settings_management_detail_tab.dart';
import 'package:xm_frontend/features/shop/screens/tenants_contracts/widgets/tenants_contracts_detail_tab.dart';
import 'package:xm_frontend/utils/constants/colors.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/loaders/loader_animation.dart';
import '../../../../../../utils/constants/sizes.dart';

class SettingsManagementTabletScreen extends StatelessWidget {
  const SettingsManagementTabletScreen({super.key, required this.roleExtId});
  final int roleExtId;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TenantController());

    final double tabViewHeight = MediaQuery.of(context).size.height * 0.7;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TBreadcrumbsWithHeading(
                heading: AppLocalization.of(
                  context,
                ).translate('sidebar.lbl_settings_and_management'),
                breadcrumbItems: const [],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              Obx(() {
                if (controller.isLoading.value) return const TLoaderAnimation();

                return TRoundedContainer(
                  child: Column(
                    children: [
                      DefaultTabController(
                        length: 2,
                        child: Column(
                          children: [
                            TabBar(
                              tabAlignment: TabAlignment.start,
                              isScrollable: true,
                              indicatorColor: TColors.alterColor,
                              labelColor: TColors.alterColor,
                              indicatorWeight: 1,
                              unselectedLabelColor: Colors.black.withOpacity(
                                0.6,
                              ),
                              tabs: [
                                Tab(
                                  text: AppLocalization.of(context).translate(
                                    'tab_settings_screen.lbl_settings',
                                  ),
                                  icon: const Icon(Iconsax.setting_2),
                                ),
                                Tab(
                                  text: AppLocalization.of(context).translate(
                                    'tab_management_screen.lbl_management',
                                  ),
                                  icon: const Icon(Iconsax.setting),
                                ),
                              ],
                            ),
                            const SizedBox(height: TSizes.defaultSpace),
                            SizedBox(
                              height: tabViewHeight,
                              child: const TabBarView(
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
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
