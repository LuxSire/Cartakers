import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
//import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:cartakers/app/localization/app_localization.dart';
//import 'package:xm_frontend/features/personalization/models/user_model.dart';
//import 'package:xm_frontend/features/shop/controllers/contract/contract_controller.dart';
//import 'package:xm_frontend/features/shop/controllers/user/user_controller.dart';
import 'package:cartakers/features/personalization/controllers/user_controller.dart';
//import 'package:xm_frontend/utils/constants/colors.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/validators/validation.dart';

class EditUserDialog extends StatelessWidget {
  const EditUserDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserController>();
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: TRoundedContainer(
        width: 500,
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Form(
          key: controller.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header with close icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalization.of(
                      context,
                    ).translate('users_screen.lbl_update_user'),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              Row(
                children: [
                  // First Name
                  Expanded(
                    child: TextFormField(
                      controller: controller.firstNameController,
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
                      controller: controller.lastNameController,
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
                readOnly: true,

                controller: controller.emailController,
                validator: TValidator.validateEmail,

                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.1),
                  prefixIcon: Icon(Iconsax.direct_right),
                  labelText: AppLocalization.of(
                    context,
                  ).translate('register_screen.lbl_email'),
                ),
              ),

              const SizedBox(height: TSizes.spaceBtwInputFields),

              /// Submit Button
              Obx(() {
                return controller.loading.value
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.submitUser,
                        child: Text(
                          AppLocalization.of(
                            context,
                          ).translate('general_msgs.msg_update'),
                        ),
                      ),
                    );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
