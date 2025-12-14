import 'package:flutter/material.dart';
import 'package:cartakers/features/authentication/screens/invitation/widgets/invitation_form.dart';
import 'package:cartakers/features/authentication/screens/invitation/widgets/invitation_header.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class InvitationScreenMobile extends StatelessWidget {
  const InvitationScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          THelperFunctions.isDarkMode(context) ? TColors.black : Colors.white,
      body: Container(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: const SingleChildScrollView(
          child: Column(
            children: [
              ///  Header
              TInvitationHeader(),

              /// Form
              TInvitationForm(),
            ],
          ),
        ),
      ),
    );
  }
}
