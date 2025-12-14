import 'package:flutter/material.dart';
import 'package:cartakers/features/authentication/screens/invitation/widgets/invitation_form.dart';
import 'package:cartakers/features/authentication/screens/invitation/widgets/invitation_header.dart';
import 'package:cartakers/features/authentication/screens/login/widgets/login_form.dart';
import '../../../../../common/widgets/layouts/templates/login_template.dart';
import 'package:cartakers/features/authentication/screens/login/widgets/login_header.dart';
class InvitationScreenDesktopTablet extends StatelessWidget {
  const InvitationScreenDesktopTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return TLoginTemplate(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TInvitationHeader(),
          TInvitationForm(),
          SizedBox(height: 32),
         // TLoginHeader(),
         // TLoginForm(),
        ],
      ),
    );
  }
}
