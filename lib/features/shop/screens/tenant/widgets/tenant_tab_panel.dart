import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/common/widgets/images/t_circular_image.dart';
import 'package:xm_frontend/features/shop/controllers/tenant/tenant_controller.dart';
import 'package:xm_frontend/features/shop/screens/tenant/widgets/tenant_detail_tab.dart';

import 'package:xm_frontend/utils/constants/colors.dart';
import 'package:xm_frontend/utils/constants/enums.dart';
import 'package:xm_frontend/utils/constants/image_strings.dart';
import 'package:xm_frontend/utils/helpers/helper_functions.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';

class TenantTabPanel extends StatelessWidget {
  const TenantTabPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TenantController>();
    final isMobile = MediaQuery.of(context).size.width < 600;

    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            final tenant = controller.tenantModel.value;

            debugPrint('Tenant: ${tenant.toJson().toString()}');
            return Wrap(
              spacing: TSizes.spaceBtwItems,
              runSpacing: TSizes.spaceBtwItems,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                TCircularImage(
                  width: 100,
                  height: 100,
                  padding: 2,
                  fit: BoxFit.cover,
                  backgroundColor: TColors.primaryBackground,
                  image:
                      tenant.profilePicture.isNotEmpty
                          ? tenant.profilePicture
                          : TImages.user,
                  imageType:
                      tenant.profilePicture.isNotEmpty
                          ? ImageType.network
                          : ImageType.asset,
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: isMobile ? 280 : 600),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tenant.fullName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        tenant.email,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      if ((tenant.contractReference ?? '').isNotEmpty)
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: TSizes.sm,
                          runSpacing: TSizes.sm,
                          children: [
                            Text(
                              '${AppLocalization.of(context).translate('tenants_screen.lbl_contract_reference')}: ',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              tenant.contractReference.toString(),
                              style: const TextStyle(color: Colors.grey),
                            ),
                            TRoundedContainer(
                              radius: TSizes.cardRadiusSm,
                              padding: const EdgeInsets.symmetric(
                                vertical: TSizes.sm,
                                horizontal: TSizes.md,
                              ),
                              backgroundColor:
                                  THelperFunctions.getUnitContractStatusColor(
                                    tenant.contractStatus!,
                                  ).withOpacity(0.1),
                              child: Text(
                                THelperFunctions.getUnitContractStatusText(
                                  tenant.contractStatus!,
                                ),
                                style: TextStyle(
                                  color: THelperFunctions.getUnitStatusColor(
                                    tenant.contractStatus!,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (tenant.isPrimaryTenant == 1)
                        Text(
                          AppLocalization.of(
                            context,
                          ).translate('tenants_screen.lbl_primary_tenant'),
                          style: const TextStyle(color: TColors.alterColor),
                        ),
                    ],
                  ),
                ),
              ],
            );
          }),

          const SizedBox(height: TSizes.spaceBtwSections),
          // Tenant Details Tabs
          DefaultTabController(
            length: 4, // Number of tabs
            child: Column(
              children: [
                // TabBar with left alignment
                TabBar(
                  tabAlignment: TabAlignment.start,
                  isScrollable: true,
                  indicatorColor:
                      TColors.alterColor, // Accent color for active tab
                  labelColor: TColors.alterColor, // Color for active tab text
                  indicatorWeight: 1,
                  unselectedLabelColor: Colors.black.withOpacity(
                    0.6,
                  ), // Color for inactive tabs

                  tabs: [
                    Tab(
                      text: AppLocalization.of(
                        context,
                      ).translate('tenant_screen.lbl_profile_information'),
                      icon: Icon(Iconsax.user),
                    ),
                    Tab(
                      text: AppLocalization.of(
                        context,
                      ).translate('contract_screen.lbl_documents'),
                      icon: Icon(Iconsax.document),
                    ),
                    Tab(
                      text: AppLocalization.of(
                        context,
                      ).translate('bookings_and_requests_screen.lbl_bookings'),

                      icon: Icon(Iconsax.calendar),
                    ),
                    Tab(
                      text: AppLocalization.of(
                        context,
                      ).translate('bookings_and_requests_screen.lbl_requests'),
                      icon: Icon(Iconsax.note),
                    ),

                    // Tab(text: 'Notes/Logs'),
                  ],
                ),
                const SizedBox(height: TSizes.defaultSpace),
                const SizedBox(
                  height: 600,
                  child: TabBarView(
                    children: [
                      // Tenant Tab
                      TenantDetailsTab(tabType: 'tenant'),
                      // Documents Tab
                      TenantDetailsTab(tabType: 'documents'),
                      // Booking History Tab
                      TenantDetailsTab(tabType: 'bookings'),
                      // Request History Tab
                      TenantDetailsTab(tabType: 'requests'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
