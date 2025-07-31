import 'package:flutter/material.dart';
import 'package:xm_frontend/features/shop/screens/bookings_requests/responsive_screens/bookings_requests_desktop.dart';
import 'package:xm_frontend/features/shop/screens/bookings_requests/responsive_screens/bookings_requests_mobile.dart';
import 'package:xm_frontend/features/shop/screens/bookings_requests/responsive_screens/bookings_requests_tablet.dart';

import 'package:xm_frontend/features/shop/screens/users_contracts/responsive_screens/users_contracts_desktop.dart';
import 'package:xm_frontend/features/shop/screens/users_contracts/responsive_screens/users_contracts_mobile.dart';
import 'package:xm_frontend/features/shop/screens/users_contracts/responsive_screens/users_contracts_tablet.dart';

import '../../../../../common/widgets/layouts/templates/site_layout.dart';

class BookingsRequestsScreen extends StatelessWidget {
  const BookingsRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TSiteTemplate(
      desktop: BookingsRequestsDesktopScreen(),
      tablet: BookingsRequestsTabletScreen(),
      mobile: BookingsRequestsMobileScreen(),
    );
  }
}
