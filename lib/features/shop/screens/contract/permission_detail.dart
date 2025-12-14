import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cartakers/features/shop/screens/object/unit_detail/responsive_screens/unit_detail_desktop.dart';
import 'package:cartakers/features/shop/screens/object/unit_detail/responsive_screens/unit_detail_mobile.dart';
import 'package:cartakers/features/shop/screens/object/unit_detail/responsive_screens/unit_detail_tablet.dart';
import 'package:cartakers/features/shop/screens/contract/responsive_screens/permission_detail_desktop.dart';
import 'package:cartakers/features/shop/screens/contract/responsive_screens/permission_detail_mobile.dart';
import 'package:cartakers/features/shop/screens/contract/responsive_screens/permission_detail_tablet.dart';

import '../../../../../common/widgets/layouts/templates/site_layout.dart';
import '../../../../../common/widgets/page_not_found/page_not_found.dart';

class PermissionDetailScreen extends StatelessWidget {
  const PermissionDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contract = Get.arguments;

    return contract != null
        ? TSiteTemplate(
          desktop: PermissionDetailDesktopScreen(contract: contract),
          tablet: PermissionDetailTabletScreen(contract: contract),
          mobile: PermissionDetailMobileScreen(contract: contract),
        )
        : const TPageNotFound();
  }
}
