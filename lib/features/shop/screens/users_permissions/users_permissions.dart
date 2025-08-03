import 'package:flutter/material.dart';

import 'package:xm_frontend/features/shop/screens/users_permissions/responsive_screens/users_permissions_desktop.dart';
import 'package:xm_frontend/features/shop/screens/users_permissions/responsive_screens/users_permissions_mobile.dart';
import 'package:xm_frontend/features/shop/screens/users_permissions/responsive_screens/users_permissions_tablet.dart';

import '../../../../../common/widgets/layouts/templates/site_layout.dart';

class UsersPermissionsScreen extends StatelessWidget {
  const UsersPermissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TSiteTemplate(
      desktop: UsersPermissionsDesktopScreen(),
      tablet: UsersPermissionsTabletScreen(),
      mobile: UsersPermissionsMobileScreen(),
    );
  }
}
