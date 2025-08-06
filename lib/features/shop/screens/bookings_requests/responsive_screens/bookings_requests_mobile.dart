import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xm_frontend/app/app_controller.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/features/shop/controllers/customer/customer_controller.dart';
//import 'package:xm_frontend/features/shop/controllers/user/user_controller.dart';
import 'package:xm_frontend/features/personalization/controllers/user_controller.dart';
import 'package:xm_frontend/features/shop/screens/bookings_requests/widgets/bookings_requests_detail_tab.dart';
import 'package:xm_frontend/features/shop/screens/users_permissions/widgets/users_permissions_detail_tab.dart';
import 'package:xm_frontend/utils/constants/colors.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/loaders/loader_animation.dart';
import '../../../../../../utils/constants/sizes.dart';

class BookingsRequestsMobileScreen extends StatelessWidget {
  const BookingsRequestsMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserController>();
    final appController = Get.find<AppController>();
    final isPendingShown = appController.navigateToPendingRequests.value;

    final int tabIndex = isPendingShown == true ? 1 : 0;

    debugPrint(
      'BookingsRequestsDesktopScreen: isPendingShown: $isPendingShown',
    );

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
                ).translate('sidebar.lbl_bookings_and_requests'),
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
                        initialIndex: tabIndex,
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
                                  text: AppLocalization.of(context).translate(
                                    'bookings_and_requests_screen.lbl_bookings',
                                  ),
                                  icon: Icon(Iconsax.calendar),
                                ),
                                Tab(
                                  text: AppLocalization.of(context).translate(
                                    'bookings_and_requests_screen.lbl_requests',
                                  ),
                                  icon: Icon(Iconsax.document),
                                ),
                              ],
                            ),
                            const SizedBox(height: TSizes.defaultSpace),
                            SizedBox(
                              height: 1000,
                              child: TabBarView(
                                children: [
                                  BookingsRequestsDetailsTab(
                                    tabType: 'bookings',
                                    isFiltered: isPendingShown,
                                  ),

                                  BookingsRequestsDetailsTab(
                                    tabType: 'requests',
                                    isFiltered: isPendingShown,
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
