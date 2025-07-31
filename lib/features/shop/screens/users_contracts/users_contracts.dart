import 'package:flutter/material.dart';

import 'package:xm_frontend/features/shop/screens/users_contracts/responsive_screens/users_contracts_desktop.dart';
import 'package:xm_frontend/features/shop/screens/users_contracts/responsive_screens/users_contracts_mobile.dart';
import 'package:xm_frontend/features/shop/screens/users_contracts/responsive_screens/users_contracts_tablet.dart';

import '../../../../../common/widgets/layouts/templates/site_layout.dart';

class UsersContractsScreen extends StatelessWidget {
  const UsersContractsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TSiteTemplate(
      desktop: UsersContractsDesktopScreen(),
      tablet: UsersContractsTabletScreen(),
      mobile: UsersContractsMobileScreen(),
    );
  }
}
