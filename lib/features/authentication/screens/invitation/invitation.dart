import 'package:flutter/material.dart';
import 'package:xm_frontend/features/authentication/screens/invitation/responsive_screens/invitation_desktop_tablet.dart';
import 'package:xm_frontend/features/authentication/screens/invitation/responsive_screens/invitation_mobile.dart';

import '../../../../common/widgets/layouts/templates/site_layout.dart';

class InvitationScreen extends StatelessWidget {
  const InvitationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TSiteTemplate(
      useLayout: false,
      desktop: InvitationScreenDesktopTablet(),
      mobile: InvitationScreenMobile(),
    );
  }
}
