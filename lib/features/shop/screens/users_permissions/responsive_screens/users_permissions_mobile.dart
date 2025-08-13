import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
//import 'package:xm_frontend/features/shop/controllers/customer/customer_controller.dart';
//import 'package:xm_frontend/features/shop/controllers/user/user_controller.dart';
//import 'package:xm_frontend/features/shop/controllers/user/user_controller.dart';
import 'package:xm_frontend/features/personalization/controllers/user_controller.dart';
import 'package:xm_frontend/features/shop/screens/users_permissions/widgets/users_permissions_detail_tab.dart';
import 'package:xm_frontend/utils/constants/colors.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/loaders/loader_animation.dart';
import '../../../../../../utils/constants/sizes.dart';

class UsersPermissionsMobileScreen extends StatelessWidget {
  const UsersPermissionsMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserController>();

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
                ).translate('sidebar.lbl_users_and_contracts'),
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
                        length: 2, // Number of tabs
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
                              text: AppLocalization.of(
                                context,
                              ).translate('users_screen.lbl_companies'),
                              icon: const Icon(Iconsax.building1),
                            ),

                            Tab(
                              text: AppLocalization.of(
                                context,
                              ).translate('users_screen.lbl_users'),
                              icon: const Icon(Iconsax.profile_2user),
                            ),                     ],
                            ),
                            const SizedBox(height: TSizes.defaultSpace),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: TabBarView(
                                children: [
                                
                              UsersPermissionsDetailTab(tabType: 'companies'),
                              UsersPermissionsDetailTab(tabType: 'users') 
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
