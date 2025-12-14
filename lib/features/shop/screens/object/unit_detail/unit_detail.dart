import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cartakers/features/shop/screens/object/unit_detail/responsive_screens/unit_detail_desktop.dart';
import 'package:cartakers/features/shop/screens/object/unit_detail/responsive_screens/unit_detail_mobile.dart';
import 'package:cartakers/features/shop/screens/object/unit_detail/responsive_screens/unit_detail_tablet.dart';

import '../../../../../common/widgets/layouts/templates/site_layout.dart';
import '../../../../../common/widgets/page_not_found/page_not_found.dart';

class UnitDetailScreen extends StatelessWidget {
  const UnitDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final unit = Get.arguments;
    debugPrint('UnitDetailDesktopScreen build called with unit: ${unit.unitNumber}');
    return unit != null
        ? TSiteTemplate(

          desktop: UnitDetailDesktopScreen(unit: unit),
          tablet: UnitDetailTabletScreen(unit: unit),
          mobile: UnitDetailMobileScreen(unit: unit),
        )
        : const TPageNotFound();
  }
}
