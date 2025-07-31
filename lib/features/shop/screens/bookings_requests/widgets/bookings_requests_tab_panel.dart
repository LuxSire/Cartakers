import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/features/shop/screens/users_contracts/widgets/users_contracts_detail_tab.dart';

import 'package:xm_frontend/utils/constants/colors.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';

class BookingsRequestsTabPanel extends StatelessWidget {
  const BookingsRequestsTabPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                      ).translate('users_screen.lbl_users'),
                      icon: Icon(Iconsax.record),
                    ),
                    Tab(
                      text: AppLocalization.of(
                        context,
                      ).translate('profile_screen.lbl_contracts'),
                      icon: Icon(Iconsax.document),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.defaultSpace),
                const SizedBox(
                  height: 400,
                  child: TabBarView(
                    children: [
                      // Users Tab
                      UsersContractsDetailTab(tabType: 'users'),
                      // contracts Tab
                      UsersContractsDetailTab(tabType: 'contracts'),
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
