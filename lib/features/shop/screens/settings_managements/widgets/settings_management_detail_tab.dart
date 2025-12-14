// lib/features/shop/screens/settings_management/widgets/settings_management_detail_tab.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:cartakers/app/localization/app_localization.dart';
import 'package:cartakers/features/personalization/controllers/user_controller.dart';
import 'package:cartakers/features/shop/screens/settings_managements/widgets/amenities_tab.dart';
import 'package:cartakers/features/shop/screens/settings_managements/widgets/preferences_tab.dart';
import 'package:cartakers/features/shop/screens/settings_managements/widgets/profile_tab.dart';
import 'package:cartakers/features/shop/screens/settings_managements/widgets/users_tab.dart';
import 'package:cartakers/utils/constants/colors.dart';
import 'package:cartakers/utils/constants/sizes.dart';

class SettingsManagementDetailsTab extends StatelessWidget {
  final String tabType;
  const SettingsManagementDetailsTab({Key? key, required this.tabType})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (tabType) {
      case 'settings':
        return DefaultTabController(
          length: 2,
          child: Column(
            children: [
              TabBar(
                indicatorColor: Theme.of(context).colorScheme.secondary,
                labelColor: Theme.of(context).colorScheme.secondary,
                unselectedLabelColor: Theme.of(context).colorScheme.primary,
                tabs: [
                  Tab(
                    text: AppLocalization.of(
                      context,
                    ).translate('tab_settings_screen.lbl_profile'),
                  ),
                  Tab(
                    text: AppLocalization.of(
                      context,
                    ).translate('tab_settings_screen.lbl_preferences'),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(children: [ProfileTab(), PreferencesTab()]),
              ),
            ],
          ),
        );

      case 'management':
        return DefaultTabController(
          length: 1,
          child: Column(
            children: [
              TabBar(
                indicatorColor: TColors.alterColor,
                labelColor: TColors.alterColor,
                unselectedLabelColor: Colors.black54,
                tabs: [
                  Tab(
                    text: AppLocalization.of(
                      context,
                    ).translate('tab_management_screen.lbl_users'),
                  ),
                  // Tab(
                  //   text: AppLocalization.of(
                  //     context,
                  //   ).translate('tab_management_screen.lbl_amenities'),
                  // ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              Expanded(child: TabBarView(children: const [UsersTab()])),
            ],
          ),
        );

      default:
        return Center(child: Text('Unknown tab: $tabType'));
    }
  }
}
