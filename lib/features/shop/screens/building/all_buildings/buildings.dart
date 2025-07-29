import 'package:flutter/material.dart';
import 'package:xm_frontend/features/shop/screens/building/all_buildings/responsive_screens/buildings_desktop.dart';
import 'package:xm_frontend/features/shop/screens/building/all_buildings/responsive_screens/buildings_mobile.dart';
import 'package:xm_frontend/features/shop/screens/building/all_buildings/responsive_screens/buildings_tablet.dart';

import '../../../../../common/widgets/layouts/templates/site_layout.dart';

class BuildingsScreen extends StatelessWidget {
  const BuildingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TSiteTemplate(
      desktop: BuildingsDesktopScreen(),
      tablet: BuildingsTabletScreen(),
      mobile: BuildingsMobileScreen(),
    );
  }
}
