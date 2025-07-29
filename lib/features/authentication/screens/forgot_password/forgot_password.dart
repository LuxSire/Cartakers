import 'package:flutter/material.dart';
import 'package:xm_frontend/features/authentication/screens/forgot_password/responsive_screens/forgot_password_desktop_tablet.dart';
import 'package:xm_frontend/features/authentication/screens/forgot_password/responsive_screens/forgot_password_mobile.dart';
import 'package:xm_frontend/features/authentication/screens/invitation/responsive_screens/invitation_desktop_tablet.dart';
import 'package:xm_frontend/features/authentication/screens/invitation/responsive_screens/invitation_mobile.dart';

import '../../../../common/widgets/layouts/templates/site_layout.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TSiteTemplate(
      useLayout: false,
      desktop: ForgotPasswordScreenDesktopTablet(),
      mobile: ForgotPasswordScreenMobile(),
    );
  }
}
