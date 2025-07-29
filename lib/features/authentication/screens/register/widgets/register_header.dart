import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/data/models/agent_invitation_model.dart';
import 'package:xm_frontend/features/authentication/controllers/register_controller.dart';
import 'package:xm_frontend/utils/constants/colors.dart';

import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';

class TRegisterHeader extends StatelessWidget {
  const TRegisterHeader({super.key, required this.agentModel});

  final AgentInvitationModel agentModel;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterController());
    controller.init(agentModel);

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image(
                width: 70,
                height: 70,
                image: AssetImage(TImages.lightAppLogo),
              ),
              const SizedBox(width: TSizes.sm),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Tenants10 ',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: TColors.alterColor,
                      ),
                    ),
                    TextSpan(
                      text: '\u00A0For Admins',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        color: TColors.alterColor.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwSections),
          Text(
            AppLocalization.of(
              context,
            ).translate('register_screen.lbl_register'),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: TSizes.sm),
          Text(
            AppLocalization.of(
              context,
            ).translate('login_screen.lbl_welcome_title'),
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          const SizedBox(height: TSizes.md),
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 6.0,
            ),
            decoration: BoxDecoration(
              color: TColors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 2.0),
                Text(
                  AppLocalization.of(context)
                      .translate('register_screen.lbl_business_info')
                      .toUpperCase(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8.0),
                Container(
                  width: double.maxFinite,
                  margin: const EdgeInsets.only(right: 10.0),
                  child: Row(
                    children: [
                      Text(
                        controller.agencyName.value,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(' - '),
                      Expanded(
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          controller.buildingAddress.value,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
