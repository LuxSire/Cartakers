import 'package:flutter/material.dart';

import 'package:cartakers/features/shop/screens/user/all_users/responsive_screens/users_desktop.dart';
import 'package:cartakers/features/shop/screens/user/all_users/responsive_screens/users_mobile.dart';
import 'package:cartakers/features/shop/screens/user/all_users/responsive_screens/users_tablet.dart';

import '../../../../../common/widgets/layouts/templates/site_layout.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TSiteTemplate(
      desktop: UsersDesktopScreen(),
      tablet: UsersTabletScreen(),
      mobile: UsersMobileScreen(),
    );
  }
}
