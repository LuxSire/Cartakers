import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cartakers/app/localization/app_localization.dart';
import 'package:cartakers/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:cartakers/common/widgets/loaders/loader_animation.dart';
import 'package:cartakers/features/personalization/controllers/user_controller.dart';
import 'package:cartakers/features/shop/screens/users_permissions/widgets/users_permissions_detail_tab.dart';
import 'package:cartakers/utils/constants/colors.dart';

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
                          indicatorColor: Theme.of(context).colorScheme.secondary,
                          labelColor: Theme.of(context).colorScheme.secondary,
                          indicatorWeight: 1,
                          unselectedLabelColor: Theme.of(context).colorScheme.primary,
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
                            ),
                            Tab(
                              text: AppLocalization.of(
                                context,
                              ).translate('users_screen.lbl_pending_users'),
                              icon: const Icon(Iconsax.profile_2user),
                            ),                     
                     
                           ],
                        ),
                        const SizedBox(height: TSizes.defaultSpace),
                        // Tab content
                        Expanded(
                          child: TabBarView(
                            children: [

                              UsersPermissionsDetailTab(tabType: 'companies'),
                              UsersPermissionsDetailTab(tabType: 'users'),
                              UsersPermissionsDetailTab(tabType: 'pendingusers'),
                             // UsersPermissionsDetailTab(tabType: 'permissions'),
                          
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
