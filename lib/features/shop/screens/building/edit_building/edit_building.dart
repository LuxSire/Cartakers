import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/features/shop/screens/building/edit_building/responsive_screens/edit_building_desktop.dart';
import 'package:xm_frontend/features/shop/screens/building/edit_building/responsive_screens/edit_building_mobile.dart';
import 'package:xm_frontend/features/shop/screens/building/edit_building/responsive_screens/edit_building_tablet.dart';

import '../../../../../common/widgets/layouts/templates/site_layout.dart';
import '../../../../../common/widgets/page_not_found/page_not_found.dart';

class EditBuildingScreen extends StatelessWidget {
  const EditBuildingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final building = Get.arguments;

    return building != null
        ? TSiteTemplate(
          desktop: EditBuildingDesktopScreen(building: building),
          tablet: EditBuildingTabletScreen(building: building),
          mobile: EditBuildingMobileScreen(building: building),
        )
        : const TPageNotFound();
  }
}
