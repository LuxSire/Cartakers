import 'package:flutter/material.dart';
import 'package:xm_frontend/features/authentication/screens/forgot_password/widgets/forgot_password_form.dart';
import 'package:xm_frontend/features/authentication/screens/forgot_password/widgets/forgot_password_header.dart';
//import 'package:xm_frontend/features/authentication/screens/invitation/widgets/invitation_form.dart';
//import 'package:xm_frontend/features/authentication/screens/invitation/widgets/invitation_header.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class ForgotPasswordScreenMobile extends StatelessWidget {
  const ForgotPasswordScreenMobile({super.key});

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
              ForgotPasswordHeader(),

              /// Form
              ForgotPasswordForm(),
            ],
          ),
        ),
      ),
    );
  }
}
