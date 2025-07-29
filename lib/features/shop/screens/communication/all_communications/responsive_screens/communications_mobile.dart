import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/features/shop/controllers/customer/customer_controller.dart';
import 'package:xm_frontend/features/shop/controllers/tenant/tenant_controller.dart';
import 'package:xm_frontend/features/shop/screens/communication/all_communications/widgets/communication_detail_tab.dart';
import 'package:xm_frontend/features/shop/screens/tenants_contracts/widgets/tenants_contracts_detail_tab.dart';
import 'package:xm_frontend/utils/constants/colors.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/loaders/loader_animation.dart';
import '../../../../../../utils/constants/sizes.dart';

class CommunicationMobileScreen extends StatelessWidget {
  const CommunicationMobileScreen({super.key});

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
              TBreadcrumbsWithHeading(
                heading: AppLocalization.of(
                  context,
                ).translate('sidebar.lbl_communication'),
                breadcrumbItems: [
                  // AppLocalization.of(
                  //   context,
                  // ).translate('tenants_screen.lbl_tenants'),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections), // Table Body
              // Table Body
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
                                  //          CommunicationDetailsTab(tabType: 'contracts'),
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
