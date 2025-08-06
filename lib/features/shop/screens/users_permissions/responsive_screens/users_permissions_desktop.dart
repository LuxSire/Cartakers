import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:xm_frontend/common/widgets/loaders/loader_animation.dart';
import 'package:xm_frontend/features/personalization/controllers/user_controller.dart';
import 'package:xm_frontend/features/shop/screens/users_permissions/widgets/users_permissions_detail_tab.dart';
import 'package:xm_frontend/utils/constants/colors.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';

class UsersPermissionsDesktopScreen extends StatelessWidget {
  const UsersPermissionsDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserController>();
    debugPrint('UsersPermissionsDesktopScreen build called');
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
              ).translate('sidebar.lbl_users_and_contracts'),
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
                              ).translate('users_screen.lbl_users'),
                              icon: const Icon(Iconsax.profile_2user),
                            ),
                            Tab(
                              text: AppLocalization.of(
                                context,
                              ).translate('users_screen.lbl_permissions'),
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
                              UsersPermissionsDetailTab(tabType: 'users'),
                              UsersPermissionsDetailTab(tabType: 'permissions'),
                              UsersPermissionsDetailTab(
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
