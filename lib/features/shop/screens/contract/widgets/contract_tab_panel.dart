import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';

import 'package:xm_frontend/features/shop/screens/contract/widgets/contract_detail_tab.dart';

import 'package:xm_frontend/utils/constants/colors.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';

class ContractTabPanel extends StatelessWidget {
  const ContractTabPanel({super.key});

  @override
  Widget build(BuildContext context) {
    // final controller = Get.find<ContractController>();

    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Contract Details Tabs
          DefaultTabController(
            length: 4, // Number of tabs
            child: Column(
              children: [
                // TabBar with left alignment
                TabBar(
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
                      ).translate('contract_screen.lbl_tenants'),
                      icon: Icon(Iconsax.profile_2user),
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
                  height: 400,
                  child: TabBarView(
                    children: [
                      // Tenants Tab
                      ContractDetailsTab(tabType: 'tenants'),
                      // Documents Tab
                      ContractDetailsTab(tabType: 'documents'),
                      // Booking History Tab
                      ContractDetailsTab(tabType: 'bookings'),
                      // Request History Tab
                      ContractDetailsTab(tabType: 'requests'),
                      // Notes/Logs Tab
                      // ContractDetailsTab(tabType: 'Notes/Logs'),
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
