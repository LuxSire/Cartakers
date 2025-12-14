import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:cartakers/app/localization/app_localization.dart';
import 'package:cartakers/common/widgets/chips/rounded_choice_chips.dart';
import 'package:cartakers/features/personalization/controllers/user_controller.dart';
import 'package:cartakers/features/personalization/controllers/company_controller.dart';
import 'package:cartakers/features/personalization/models/user_model.dart';
import 'package:cartakers/features/shop/controllers/contract/permission_controller.dart';
//import 'package:xm_frontend/features/shop/controllers/user/user_controller.dart';
import 'package:cartakers/utils/constants/colors.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/validators/validation.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:cartakers/utils/popups/pdf_viewer.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html; // Only for web

class TokenRequestDialog extends StatelessWidget {
  const TokenRequestDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserController>();
    final companyController = Get.find<CompanyController>();
    controller.loadAllUserRoles();
  // Debug print user roles
    debugPrint('User roles loaded: ${controller.userRolesList.map((r) => '${r.id}:${r.nameTranslated}').toList()}');


    //  controller.loadAllBuildings();

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
                    ).translate('tab_users_screen.lbl_new_user'),
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
                        ).translate('tab_users_screen.lbl_first_name'),
                        label: Text(
                          AppLocalization.of(
                            context,
                          ).translate('tab_users_screen.lbl_first_name'),
                        ),
                        prefixIcon: Icon(Iconsax.user),
                      ),
                      validator:
                          (value) => TValidator.validateEmptyText(
                            AppLocalization.of(
                              context,
                            ).translate('tab_users_screen.lbl_first_name'),
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
                        ).translate('tab_users_screen.lbl_last_name'),
                        label: Text(
                          AppLocalization.of(
                            context,
                          ).translate('tab_users_screen.lbl_last_name'),
                        ),
                        prefixIcon: Icon(Iconsax.user),
                      ),
                      validator:
                          (value) => TValidator.validateEmptyText(
                            AppLocalization.of(
                              context,
                            ).translate('tab_users_screen.lbl_last_name'),
                            value,
                          ),
                    ),
                  ),
                ],
              ),


              /// Phone Number
              TextFormField(
                controller: controller.phoneController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Iconsax.call),
                  labelText: AppLocalization.of(
                    context,
                  ).translate('register_screen.lbl_phone_no'),
                ),
              ),

              const SizedBox(height: TSizes.spaceBtwInputFields),

              /// Email
              TextFormField(
                controller: controller.emailController,
                validator: TValidator.validateEmail,

                decoration: InputDecoration(
                  prefixIcon: Icon(Iconsax.direct_right),
                  labelText: AppLocalization.of(
                    context,
                  ).translate('tab_users_screen.lbl_email'),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),
                /// Message
              TextFormField(
                controller: controller.messageController,

                decoration: InputDecoration(
                  prefixIcon: Icon(Iconsax.direct_right),
                  labelText: AppLocalization.of(
                    context,
                  ).translate('tab_users_screen.lbl_message'),
                ),
              ),
/*
Row(
  children: [
    Obx(() => Checkbox(
      value: controller.ndaAccepted.value,
      onChanged: (val) => controller.ndaAccepted.value = val ?? false,
    )),
    Text(AppLocalization.of(context).translate('general_msgs.msg_accept_nda')),
    const SizedBox(width: 8),
    MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if (kIsWeb) {
            html.window.open('assets/docs/NDA.pdf', '_blank');
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const PDFViewerScreen(assetPath: 'assets/docs/NDA.pdf'),
              ),
            );
          }
        },
        child: Text(
          'NDA',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    ),
  ],
),  
*/

const SizedBox(height: TSizes.spaceBtwInputFields),

/// Submit Button
Obx(() {
  return controller.loading.value
      ? const Center(child: CircularProgressIndicator())
      : SizedBox(
          width: double.infinity,
          child: ElevatedButton(
           onPressed: controller.ndaAccepted.value
              ? () {
                controller.selectedRoleId.value = 4;
                controller.submitUser();
                    }
              : null,
            child: Text(
              AppLocalization.of(context).translate('general_msgs.msg_request'),
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
