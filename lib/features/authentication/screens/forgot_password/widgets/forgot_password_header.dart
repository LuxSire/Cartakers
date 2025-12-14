import 'package:flutter/material.dart';
import 'package:cartakers/app/localization/app_localization.dart';
import 'package:cartakers/utils/constants/colors.dart';

import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/constants/text_strings.dart';

class ForgotPasswordHeader extends StatelessWidget {
  const ForgotPasswordHeader({super.key});

  @override
  Widget build(BuildContext context) {
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
                      text: 'XM ',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: TColors.alterColor,
                      ),
                    ),
                    TextSpan(
                      text: '\u00A0Dashboard',
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
            ).translate('forgot_password_screen.lbl_forgot_password'),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: TSizes.sm),
          Text(
            AppLocalization.of(
              context,
            ).translate('forgot_password_screen.lbl_content'),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
