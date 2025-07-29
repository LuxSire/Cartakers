import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xm_frontend/app/app_controller.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/features/authentication/controllers/invitation_controller.dart';
import 'package:xm_frontend/routes/routes.dart';
import 'package:xm_frontend/utils/constants/colors.dart';

import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/validators/validation.dart';
import '../../../controllers/login_controller.dart';

class TInvitationForm extends StatelessWidget {
  const TInvitationForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InvitationController());
    final appController = Get.find<AppController>();

    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return Form(
      key: controller.invitationFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
        child: Column(
          children: [
            /// invitation
            TextFormField(
              controller: controller.invitation,
              validator:
                  (value) => TValidator.validateEmptyText(
                    AppLocalization.of(
                      context,
                    ).translate('invitation_screen.lbl_invitation_code'),
                    value,
                  ),
              decoration: InputDecoration(
                prefixIcon: Icon(Iconsax.text_block),
                labelText: AppLocalization.of(
                  context,
                ).translate('invitation_screen.lbl_invitation_code'),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            /// Already have an account
            TextButton(
              onPressed: () => Get.toNamed(Routes.login),
              child: Text(
                AppLocalization.of(
                  context,
                ).translate('invitation_screen.lbl_already_have_an_account'),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// Sign In Button
            SizedBox(
              width: double.infinity,
              // Un Comment this line to register admin
              // child: ElevatedButton(onPressed: () => controller.registerAdmin(), child: const Text('Register Admin')),
              child: ElevatedButton(
                onPressed: () => controller.validateCode(),
                child: Text(
                  AppLocalization.of(
                    context,
                  ).translate('invitation_screen.lbl_validate'),
                ),
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwSections),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        const newLocale = Locale('de', 'CH');
                        appController.changeLanguage(newLocale);
                      },
                      child: Text(
                        AppLocalization.of(
                          context,
                        ).translate('language_selection.lbl_de'),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        const newLocale = Locale('fr', 'CH');
                        appController.changeLanguage(newLocale);
                      },
                      child: Text(
                        AppLocalization.of(
                          context,
                        ).translate('language_selection.lbl_fr'),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        const newLocale = Locale('it', 'CH');
                        appController.changeLanguage(newLocale);
                      },
                      child: Text(
                        AppLocalization.of(
                          context,
                        ).translate('language_selection.lbl_it'),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        const newLocale = Locale('en', 'US');
                        appController.changeLanguage(newLocale);
                      },
                      child: Text(
                        AppLocalization.of(
                          context,
                        ).translate('language_selection.lbl_en'),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
