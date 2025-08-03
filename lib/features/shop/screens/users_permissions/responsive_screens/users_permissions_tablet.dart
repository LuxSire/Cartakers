import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/features/shop/controllers/user/user_controller.dart';
import 'package:xm_frontend/features/shop/screens/users_permissions/widgets/users_permissions_detail_tab.dart';
import 'package:xm_frontend/utils/constants/colors.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/loaders/loader_animation.dart';
import '../../../../../../utils/constants/sizes.dart';

class UsersPermissionsTabletScreen extends StatelessWidget {
  const UsersPermissionsTabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserController>();

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
                ).translate('sidebar.lbl_users_and_contracts'),
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
                                  text: AppLocalization.of(
                                    context,
                                  ).translate('users_screen.lbl_users'),
                                  icon: const Icon(Iconsax.profile_2user),
                                ),
                                Tab(
                                  text: AppLocalization.of(
                                    context,
                                  ).translate('profile_screen.lbl_permissions'),
                                  icon: const Icon(Iconsax.note_2),
                                ),
                              ],
                            ),
                            const SizedBox(height: TSizes.defaultSpace),
                            SizedBox(
                              height: tabViewHeight,
                              child: const TabBarView(
                                children: [
                                  UsersPermissionsDetailTab(
                                    tabType: 'users',
                                  ),
                                  UsersPermissionsDetailTab(
                                    tabType: 'permissions',
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
