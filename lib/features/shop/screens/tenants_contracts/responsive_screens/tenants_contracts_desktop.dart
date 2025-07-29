import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:xm_frontend/common/widgets/loaders/loader_animation.dart';
import 'package:xm_frontend/features/shop/controllers/tenant/tenant_controller.dart';
import 'package:xm_frontend/features/shop/screens/tenants_contracts/widgets/tenants_contracts_detail_tab.dart';
import 'package:xm_frontend/utils/constants/colors.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';

class TenantsContractsDesktopScreen extends StatelessWidget {
  const TenantsContractsDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TenantController());

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
              ).translate('sidebar.lbl_tenants_and_contracts'),
              breadcrumbItems: const [],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Main content
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) return const TLoaderAnimation();

                return TRoundedContainer(
                  child: DefaultTabController(
                    length: 3,
                    child: Column(
                      children: [
                        // TabBar with left alignment
                        TabBar(
                          tabAlignment: TabAlignment.start,
                          isScrollable: true,
                          indicatorColor: TColors.alterColor,
                          labelColor: TColors.alterColor,
                          indicatorWeight: 1,
                          unselectedLabelColor: Colors.black.withOpacity(0.6),
                          tabs: [
                            Tab(
                              text: AppLocalization.of(
                                context,
                              ).translate('tenants_screen.lbl_tenants'),
                              icon: const Icon(Iconsax.profile_2user),
                            ),
                            Tab(
                              text: AppLocalization.of(
                                context,
                              ).translate('profile_screen.lbl_contracts'),
                              icon: const Icon(Iconsax.note_2),
                            ),
                            Tab(
                              text: AppLocalization.of(context).translate(
                                'tab_app_invitation_screen.lbl_app_invitation',
                              ),
                              icon: const Icon(Iconsax.device_message),
                            ),
                          ],
                        ),
                        const SizedBox(height: TSizes.defaultSpace),
                        // Tab content
                        Expanded(
                          child: TabBarView(
                            children: [
                              TenantsContractsDetailsTab(tabType: 'tenants'),
                              TenantsContractsDetailsTab(tabType: 'contracts'),
                              TenantsContractsDetailsTab(
                                tabType: 'app_invitation',
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
