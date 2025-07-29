import 'package:flutter/material.dart';
import 'package:xm_frontend/features/authentication/screens/invitation/widgets/invitation_form.dart';
import 'package:xm_frontend/features/authentication/screens/invitation/widgets/invitation_header.dart';

import '../../../../../common/widgets/layouts/templates/login_template.dart';

class InvitationScreenDesktopTablet extends StatelessWidget {
  const InvitationScreenDesktopTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return const TLoginTemplate(
      child: Column(
        children: [
          ///  Header
          TInvitationHeader(),

          /// Form
          TInvitationForm(),
        ],
      ),
    );
  }
}
