import 'package:flutter/material.dart';
import 'package:xm_frontend/data/models/agent_invitation_model.dart';
import 'package:xm_frontend/features/authentication/screens/register/widgets/register_form.dart';
import 'package:xm_frontend/features/authentication/screens/register/widgets/register_header.dart';

import '../../../../../common/widgets/layouts/templates/login_template.dart';

class RegisterScreenDesktopTablet extends StatelessWidget {
  const RegisterScreenDesktopTablet({super.key, required this.agentModel});

  final AgentInvitationModel agentModel;

  @override
  Widget build(BuildContext context) {
    return TLoginTemplate(
      child: Column(
        children: [
          ///  Header
          TRegisterHeader(agentModel: agentModel),

          /// Form
          TRegisterForm(agentModel: agentModel),
        ],
      ),
    );
  }
}
