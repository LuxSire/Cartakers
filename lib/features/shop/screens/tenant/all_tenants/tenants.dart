import 'package:flutter/material.dart';

import 'package:xm_frontend/features/shop/screens/tenant/all_tenants/responsive_screens/tenants_desktop.dart';
import 'package:xm_frontend/features/shop/screens/tenant/all_tenants/responsive_screens/tenants_mobile.dart';
import 'package:xm_frontend/features/shop/screens/tenant/all_tenants/responsive_screens/tenants_tablet.dart';

import '../../../../../common/widgets/layouts/templates/site_layout.dart';

class TenantsScreen extends StatelessWidget {
  const TenantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TSiteTemplate(
      desktop: TenantsDesktopScreen(),
      tablet: TenantsTabletScreen(),
      mobile: TenantsMobileScreen(),
    );
  }
}
