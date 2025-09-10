import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/routes/routes.dart';
import 'package:xm_frontend/utils/constants/colors.dart';

import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/validators/validation.dart';
import '../../../controllers/login_controller.dart';

class TLoginForm extends StatelessWidget {
  const TLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Form(
      key: controller.loginFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
        child: Column(
          children: [
            /// Email
            TextFormField(
              controller: controller.email,
              validator: TValidator.validateEmail,
              decoration: InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: AppLocalization.of(
                  context,
                ).translate('login_screen.lbl_email'),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            /// Password
Obx(
  () => TextFormField(
    obscureText: controller.hidePassword.value,
    controller: controller.password,
    validator: (value) => TValidator.validateEmptyText(
      AppLocalization.of(context).translate('login_screen.lbl_password'),
      value,
    ),
    decoration: InputDecoration(
      labelText: AppLocalization.of(context).translate('login_screen.lbl_password'),
      prefixIcon: const Icon(Iconsax.password_check),
      suffixIcon: IconButton(
        onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
        icon: Icon(
          controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye,
        ),
      ),
    ),
    textInputAction: TextInputAction.done, // <-- add this
    onFieldSubmitted: (_) => controller.emailAndPasswordSignIn(), // <-- add this
  ),
),
            const SizedBox(height: TSizes.spaceBtwInputFields / 2),

            /// Remember Me & Forget Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Remember Me
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(
                      () => Checkbox(
                        activeColor: TColors.primary,
                        value: controller.rememberMe.value,
                        onChanged:
                            (value) => controller.rememberMe.value = value!,
                      ),
                    ),
                    Text(
                      AppLocalization.of(
                        context,
                      ).translate('login_screen.lbl_remember_me'),
                    ),
                  ],
                ),

                /// Forget Password
                TextButton(
                  onPressed: () => Get.toNamed(Routes.forgotPassword),
                  child: Text(
                    AppLocalization.of(
                      context,
                    ).translate('login_screen.lbl_forgot_password'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// Sign In Button
            SizedBox(
              width: double.infinity,
              // Un Comment this line to register admin
              // child: ElevatedButton(onPressed: () => controller.registerAdmin(), child: const Text('Register Admin')),
              child: ElevatedButton(
                onPressed: () => controller.emailAndPasswordSignIn(),
                child: Text(
                  AppLocalization.of(
                    context,
                  ).translate('login_screen.lbl_login'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
