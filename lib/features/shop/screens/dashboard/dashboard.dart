import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:xm_frontend/features/shop/screens/dashboard/responsive_screens/dashboard_desktop.dart';
import 'package:xm_frontend/features/shop/screens/dashboard/responsive_screens/dashboard_mobile.dart';
import 'package:xm_frontend/features/shop/screens/dashboard/responsive_screens/dashboard_tablet.dart';

import '../../../../common/widgets/layouts/templates/site_layout.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TSiteTemplate(
      desktop: DashboardDesktopScreen(),
      tablet: DashboardTabletScreen(),
      mobile: DashboardMobileScreen(),
    );
  }
}
