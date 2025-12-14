import 'package:flutter/material.dart';
import 'package:cartakers/data/models/company_invitation_model.dart';
import 'package:cartakers/features/authentication/screens/register/widgets/register_form.dart';
import 'package:cartakers/features/authentication/screens/register/widgets/register_header.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class RegisterScreenMobile extends StatelessWidget {
  const RegisterScreenMobile({super.key, required this.companyModel});

  final CompanyInvitationModel companyModel;

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
              TRegisterHeader(companyModel: companyModel),

              /// Form
              TRegisterForm(companyModel: companyModel),
            ],
          ),
        ),
      ),
    );
  }
}
