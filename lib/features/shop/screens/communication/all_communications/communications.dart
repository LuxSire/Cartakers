import 'package:flutter/material.dart';
import 'package:xm_frontend/features/shop/screens/communication/all_communications/responsive_screens/communications_desktop.dart';
import 'package:xm_frontend/features/shop/screens/communication/all_communications/responsive_screens/communications_mobile.dart';
import 'package:xm_frontend/features/shop/screens/communication/all_communications/responsive_screens/communications_tablet.dart';

import '../../../../../common/widgets/layouts/templates/site_layout.dart';

class CommunicationScreen extends StatelessWidget {
  const CommunicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TSiteTemplate(
      desktop: CommunicationDesktopScreen(),
      tablet: CommunicationTabletScreen(),
      mobile: CommunicationMobileScreen(),
    );
  }
}
