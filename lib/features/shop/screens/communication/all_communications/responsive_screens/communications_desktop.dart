import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:xm_frontend/common/widgets/loaders/loader_animation.dart';
import 'package:xm_frontend/features/shop/controllers/building/building_controller.dart';
import 'package:xm_frontend/features/shop/controllers/tenant/tenant_controller.dart';
import 'package:xm_frontend/features/shop/screens/communication/all_communications/widgets/communication_detail_tab.dart';
import 'package:xm_frontend/features/shop/screens/tenant/all_tenants/widgets/table_header.dart';
import 'package:xm_frontend/features/shop/screens/tenants_contracts/widgets/tenants_contracts_detail_tab.dart';
import 'package:xm_frontend/utils/constants/colors.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';

class CommunicationDesktopScreen extends StatelessWidget {
  const CommunicationDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TenantController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              TBreadcrumbsWithHeading(
                heading: AppLocalization.of(
                  context,
                ).translate('sidebar.lbl_communication'),
                breadcrumbItems: [
                  // AppLocalization.of(
                  //   context,
                  // ).translate('sidebar.lbl_tenants_and_contracts'),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              Obx(() {
                if (controller.isLoading.value) return const TLoaderAnimation();
                return TRoundedContainer(
                  child: Column(
                    children: [
                      DefaultTabController(
                        length: 1, // Number of tabs
                        child: Column(
                          children: [
                            // TabBar with left alignment
                            TabBar(
                              tabAlignment: TabAlignment.start,
                              isScrollable: true,
                              indicatorColor:
                                  TColors
                                      .alterColor, // Accent color for active tab
                              labelColor:
                                  TColors
                                      .alterColor, // Color for active tab text
                              indicatorWeight: 1,
                              unselectedLabelColor: Colors.black.withOpacity(
                                0.6,
                              ), // Color for inactive tabs

                              tabs: [
                                Tab(
                                  text: AppLocalization.of(context).translate(
                                    'communication_screen.lbl_messages',
                                  ),
                                  icon: Icon(Iconsax.message),
                                ),
                                // Tab(
                                //   text: AppLocalization.of(
                                //     context,
                                //   ).translate('profile_screen.lbl_contracts'),
                                //   icon: Icon(Iconsax.note_2),
                                // ),
                              ],
                            ),
                            const SizedBox(height: TSizes.defaultSpace),
                            const SizedBox(
                              height: 1000,
                              child: TabBarView(
                                children: [
                                  // messages Tab
                                  CommunicationDetailsTab(tabType: 'messages'),
                                  // contracts Tab
                                  //     CommunicationDetailsTab(tabType: 'contracts'),
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
