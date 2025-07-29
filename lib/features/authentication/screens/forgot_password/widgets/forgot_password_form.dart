import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xm_frontend/app/app_controller.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/features/authentication/controllers/invitation_controller.dart';
import 'package:xm_frontend/presentation/widgets/custom_pin_code_text_field.dart';
import 'package:xm_frontend/routes/routes.dart';
import 'package:xm_frontend/utils/constants/colors.dart';

import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/validators/validation.dart';
import '../../../controllers/login_controller.dart';

class ForgotPasswordForm extends StatelessWidget {
  const ForgotPasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final appController = Get.find<AppController>();

    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return Form(
      key: controller.forgotPasswordFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
        child: Column(
          children: [
            Obx(() {
              if (controller.hideForgotPassword.value) {
                return const SizedBox.shrink();
              }
              return Column(
                children: [
                  /// Email
                  TextFormField(
                    controller: controller.email,
                    validator: TValidator.validateEmail,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Iconsax.direct_right),
                      labelText: AppLocalization.of(
                        context,
                      ).translate('forgot_password_screen.lbl_email'),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  /// Sign In Button
                  SizedBox(
                    width: double.infinity,
                    // Un Comment this line to register admin
                    // child: ElevatedButton(onPressed: () => controller.registerAdmin(), child: const Text('Register Admin')),
                    child: ElevatedButton(
                      onPressed:
                          () => controller.sendPasswordResetEmail(
                            context,
                            controller.email.text.trim(),
                          ),
                      child: Text(
                        AppLocalization.of(context).translate(
                          'forgot_password_screen.lbl_send_reset_code',
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: TSizes.spaceBtwSections),
                ],
              );
            }),

            Obx(() {
              if (controller.hideForgotPassword.value) {
                return Column(
                  children: [
                    if (controller.showNewPassword.value == false) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(left: 0.0),
                          child: Text(
                            AppLocalization.of(
                              context,
                            ).translate('forgot_password_screen.lbl_enter_otp'),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 25.0),
                      Container(
                        width: double.maxFinite,
                        margin: const EdgeInsets.only(left: 8.0),
                        child: CustomPinCodeTextField(
                          context: context,
                          textStyle: theme.textTheme.bodyMedium,
                          controller: controller.otpController,
                          onChanged: (value) {
                            controller.otpController.text = value;
                          },
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields),
                      SizedBox(
                        width: double.infinity,
                        // Un Comment this line to register admin
                        // child: ElevatedButton(onPressed: () => controller.registerAdmin(), child: const Text('Register Admin')),
                        child: ElevatedButton(
                          onPressed: () => controller.verifyCode(context),
                          child: Text(
                            AppLocalization.of(
                              context,
                            ).translate('forgot_password_screen.lbl_verify'),
                          ),
                        ),
                      ),
                    ],

                    if (controller.showNewPassword.value) ...[
                      const SizedBox(height: TSizes.spaceBtwSections),

                      /// New Password
                      TextFormField(
                        controller: controller.newPasswordController,
                        obscureText: true,
                        validator: TValidator.validatePassword,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Iconsax.lock),
                          labelText: AppLocalization.of(
                            context,
                          ).translate('reset_password_screen.lbl_new_password'),
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields),

                      /// Confirm New Password
                      TextFormField(
                        controller: controller.confirmNewPasswordController,
                        obscureText: true,
                        validator:
                            (value) => TValidator.validatePasswordConfirmation(
                              value,
                              controller.newPasswordController.text.trim(),
                            ),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Iconsax.lock),
                          labelText: AppLocalization.of(context).translate(
                            'reset_password_screen.lbl_confirm_password',
                          ),
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields),

                      /// Update Password Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => controller.updatePassword(context),
                          child: Text(
                            AppLocalization.of(context).translate(
                              'reset_password_screen.lbl_update_password',
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: TSizes.spaceBtwSections),
                    ],
                  ],
                );
              }
              return const SizedBox.shrink();
            }),

            TextButton(
              onPressed: () => Get.toNamed(Routes.login),
              child: Text(
                AppLocalization.of(
                  context,
                ).translate('forgot_password_screen.lbl_back_to_login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
