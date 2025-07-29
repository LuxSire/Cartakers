import 'package:flutter/material.dart';
import 'package:xm_frontend/data/models/agent_invitation_model.dart';
import 'package:xm_frontend/features/authentication/screens/register/widgets/register_form.dart';
import 'package:xm_frontend/features/authentication/screens/register/widgets/register_header.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class RegisterScreenMobile extends StatelessWidget {
  const RegisterScreenMobile({super.key, required this.agentModel});

  final AgentInvitationModel agentModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          THelperFunctions.isDarkMode(context) ? TColors.black : Colors.white,
      body: Container(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ///  Header
              TRegisterHeader(agentModel: agentModel),

              /// Form
              TRegisterForm(agentModel: agentModel),
            ],
          ),
        ),
      ),
    );
  }
}
