import 'package:flutter/material.dart';
import 'package:cartakers/features/authentication/screens/forgot_password/widgets/forgot_password_form.dart';
import 'package:cartakers/features/authentication/screens/forgot_password/widgets/forgot_password_header.dart';
import 'package:cartakers/features/authentication/screens/invitation/widgets/invitation_form.dart';
import 'package:cartakers/features/authentication/screens/invitation/widgets/invitation_header.dart';

import '../../../../../common/widgets/layouts/templates/login_template.dart';

class ForgotPasswordScreenDesktopTablet extends StatelessWidget {
  const ForgotPasswordScreenDesktopTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return const TLoginTemplate(
      child: Column(
        children: [
          ///  Header
          ForgotPasswordHeader(),

          /// Form
          ForgotPasswordForm(),
        ],
      ),
    );
  }
}
