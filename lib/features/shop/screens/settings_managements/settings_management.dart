import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/features/personalization/controllers/user_controller.dart';
import 'package:xm_frontend/features/shop/screens/settings_managements/responsive_screens/settings_management_desktop.dart';
import 'package:xm_frontend/features/shop/screens/settings_managements/responsive_screens/settings_management_mobile.dart';
import 'package:xm_frontend/features/shop/screens/settings_managements/responsive_screens/settings_management_tablet.dart';

import '../../../../../common/widgets/layouts/templates/site_layout.dart';

class SettingsManagementScreen extends StatelessWidget {
  const SettingsManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());

    // post frame callback to ensure data is loaded after first build
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await userController.fetchUserDetails();
    });

    return TSiteTemplate(
      desktop: SettingsManagementDesktopScreen(
        roleExtId: userController.user.value.roleExtId ?? 0,
      ),
      tablet: SettingsManagementTabletScreen(
        roleExtId: userController.user.value.roleExtId ?? 0,
      ),
      mobile: SettingsManagementMobileScreen(
        roleExtId: userController.user.value.roleExtId ?? 0,
      ),
    );
  }
}
