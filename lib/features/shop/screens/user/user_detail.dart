import 'package:flutter/material.dart';
import 'package:get/get.dart';

//import 'package:xm_frontend/features/shop/screens/object/unit_detail/responsive_screens/unit_detail_desktop.dart';
//import 'package:xm_frontend/features/shop/screens/object/unit_detail/responsive_screens/unit_detail_mobile.dart';
//import 'package:xm_frontend/features/shop/screens/object/unit_detail/responsive_screens/unit_detail_tablet.dart';
//import 'package:xm_frontend/features/shop/screens/contract/responsive_screens/contract_detail_desktop.dart';
//import 'package:xm_frontend/features/shop/screens/contract/responsive_screens/contract_detail_mobile.dart';
//import 'package:xm_frontend/features/shop/screens/contract/responsive_screens/contract_detail_tablet.dart';
import 'package:cartakers/features/shop/screens/user/responsive_screens/user_detail_desktop.dart';
import 'package:cartakers/features/shop/screens/user/responsive_screens/user_detail_mobile.dart';
import 'package:cartakers/features/shop/screens/user/responsive_screens/user_detail_tablet.dart';

import '../../../../../common/widgets/layouts/templates/site_layout.dart';
import '../../../../../common/widgets/page_not_found/page_not_found.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Get.arguments;

    //  debugPrint(user);

    return user != null
        ? TSiteTemplate(
          desktop: UserDetailDesktopScreen(user: user),
          tablet: UserDetailTabletScreen(user: user),
          mobile: UserDetailMobileScreen(user: user),
        )
        : const TPageNotFound();
  }
}
