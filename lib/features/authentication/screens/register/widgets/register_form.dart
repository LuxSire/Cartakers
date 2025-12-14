import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cartakers/app/localization/app_localization.dart';
import 'package:cartakers/data/models/company_invitation_model.dart';
import 'package:cartakers/features/authentication/controllers/register_controller.dart';
import 'package:cartakers/routes/routes.dart';

import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/validators/validation.dart';

class TRegisterForm extends StatelessWidget {
  const TRegisterForm({super.key, required this.companyModel});

  final CompanyInvitationModel companyModel;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterController());
    controller.init(companyModel);
    return Form(
      key: controller.registerFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
        child: Column(
          children: [
            Row(
              children: [
                // First Name
                Expanded(
                  child: TextFormField(
                    controller: controller.firstName,
                    decoration: InputDecoration(
                      hintText: AppLocalization.of(
                        context,
                      ).translate('register_screen.lbl_first_name'),
                      label: Text(
                        AppLocalization.of(
                          context,
                        ).translate('register_screen.lbl_first_name'),
                      ),
                      prefixIcon: Icon(Iconsax.user),
                    ),
                    validator:
                        (value) => TValidator.validateEmptyText(
                          AppLocalization.of(
                            context,
                          ).translate('register_screen.lbl_first_name'),
                          value,
                        ),
                  ),
                ),
                const SizedBox(width: TSizes.spaceBtwInputFields),
                // Last Name
                Expanded(
                  child: TextFormField(
                    controller: controller.lastName,
                    decoration: InputDecoration(
                      hintText: AppLocalization.of(
                        context,
                      ).translate('register_screen.lbl_last_name'),
                      label: Text(
                        AppLocalization.of(
                          context,
                        ).translate('register_screen.lbl_last_name'),
                      ),
                      prefixIcon: Icon(Iconsax.user),
                    ),
                    validator:
                        (value) => TValidator.validateEmptyText(
                          AppLocalization.of(
                            context,
                          ).translate('register_screen.lbl_last_name'),
                          value,
                        ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: TSizes.spaceBtwInputFields),

            /// Email
            TextFormField(
              controller: controller.email,
              validator: TValidator.validateEmail,
              readOnly: true,

              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],

                prefixIcon: Icon(Iconsax.direct_right),
                labelText: AppLocalization.of(
                  context,
                ).translate('register_screen.lbl_email'),
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwInputFields),

            /// Password
            Obx(
              () => TextFormField(
                obscureText: controller.hidePassword.value,
                controller: controller.password,
                validator: (value) => TValidator.validatePassword(value),
                decoration: InputDecoration(
                  labelText: AppLocalization.of(
                    context,
                  ).translate('register_screen.lbl_password'),
                  prefixIcon: const Icon(Iconsax.password_check),
                  suffixIcon: IconButton(
                    onPressed:
                        () =>
                            controller.hidePassword.value =
                                !controller.hidePassword.value,
                    icon: Icon(
                      controller.hidePassword.value
                          ? Iconsax.eye_slash
                          : Iconsax.eye,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwInputFields),

            /// Confirm Password
            Obx(
              () => TextFormField(
                obscureText: controller.hideConfirmPassword.value,
                controller: controller.confirmPassword,
                validator:
                    (value) => TValidator.validatePasswordConfirmation(
                      controller.password.text,
                      value,
                    ),
                decoration: InputDecoration(
                  labelText: AppLocalization.of(
                    context,
                  ).translate('register_screen.lbl_confirm_password'),
                  prefixIcon: const Icon(Iconsax.password_check),
                  suffixIcon: IconButton(
                    onPressed:
                        () =>
                            controller.hideConfirmPassword.value =
                                !controller.hideConfirmPassword.value,
                    icon: Icon(
                      controller.hideConfirmPassword.value
                          ? Iconsax.eye_slash
                          : Iconsax.eye,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwSections),

            /// Sign In Button
            SizedBox(
              width: double.infinity,
              // Un Comment this line to register admin
              // child: ElevatedButton(onPressed: () => controller.registerAdmin(), child: const Text('Register Admin')),
              child: ElevatedButton(
                onPressed: () => controller.registerAdmin(),
                child: Text(
                  AppLocalization.of(
                    context,
                  ).translate('register_screen.lbl_register'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
