import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/features/authentication/screens/register/responsive_screens/register_desktop_tablet.dart';
import 'package:xm_frontend/features/authentication/screens/register/responsive_screens/register_mobile.dart';

import '../../../../common/widgets/layouts/templates/site_layout.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final agent = Get.arguments;
    return TSiteTemplate(
      useLayout: false,
      desktop: RegisterScreenDesktopTablet(agentModel: agent),
      mobile: RegisterScreenMobile(agentModel: agent),
    );
  }
}
