import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/common/widgets/chips/rounded_choice_chips.dart';
import 'package:xm_frontend/common/widgets/images/image_uploader.dart';
import 'package:xm_frontend/features/personalization/controllers/company_controller.dart';
import 'package:xm_frontend/features/personalization/controllers/user_controller.dart';
import 'package:xm_frontend/features/personalization/models/user_model.dart';
import 'package:xm_frontend/features/shop/controllers/contract/permission_controller.dart';
import 'package:xm_frontend/utils/constants/colors.dart';
import 'package:xm_frontend/utils/constants/enums.dart';
import 'package:xm_frontend/utils/constants/image_strings.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/validators/validation.dart';

class EditUserDialog extends StatefulWidget {
  final bool showExtraFields;
  const EditUserDialog({super.key, required this.showExtraFields});

  @override
  State<EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  late final UserController controller;
  late final CompanyController company_controller;
  late final UserModel user;
  @override
  void initState() {
    super.initState();
    debugPrint('EditUserDialog initialized with showExtraFields: ${widget.showExtraFields}');
    controller = Get.find<UserController>();
    company_controller=Get.find<CompanyController>();
    user = controller.userModel.value;
    controller.firstNameController.text = user.firstName;
    controller.phoneController.text = user.phoneNumber ?? '';
    controller.lastNameController.text = user.lastName;
    controller.displayNameController.text = user.displayName;
    controller.emailController.text = user.email;
    controller.selectedRoleId.value = user.roleId ?? 0;
    controller.selectedCompanyId.value = user.companyId ?? 0;
    controller.memoryBytes.value = null;
    debugPrint('user edit : ${controller.userModel.value.profilePicture}');

    // Add other initializations if needed
  }

  @override
  Widget build(BuildContext context) {
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
            children: 
            [
              // Header with close icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalization.of(context).translate('tab_settings_screen.lbl_update_profile'),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Profile image
Obx(() => Center(
  child: TImageUploader(
    width: 110,
    height: 110,
    image: controller.memoryBytes.value != null
        ? '' // Not needed, memoryImage will be used
        : (controller.userModel.value.profilePicture.isNotEmpty
            ? controller.userModel.value.profilePicture
            : TImages.user),
    imageType: controller.memoryBytes.value != null
        ? ImageType.memory
        : (controller.userModel.value.profilePicture.isNotEmpty
            ? ImageType.network
            : ImageType.asset),
    memoryImage: controller.memoryBytes.value,
    onIconButtonPressed: () => controller.pickImage(),
  ),
)),

              const SizedBox(height: TSizes.spaceBtwSections),

              Row(
                children: [
                  // First Name
                  Expanded(
                    child: TextFormField(
                      controller: controller.firstNameController,
                      decoration: InputDecoration(
                        hintText: AppLocalization.of(context).translate('register_screen.lbl_first_name'),
                        label: Text(AppLocalization.of(context).translate('register_screen.lbl_first_name')),
                        prefixIcon: Icon(Iconsax.user),
                      ),
                      validator: (value) => TValidator.validateEmptyText(
                        AppLocalization.of(context).translate('register_screen.lbl_first_name'),
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
                        hintText: AppLocalization.of(context).translate('register_screen.lbl_last_name'),
                        label: Text(AppLocalization.of(context).translate('register_screen.lbl_last_name')),
                        prefixIcon: Icon(Iconsax.user),
                      ),
                      validator: (value) => TValidator.validateEmptyText(
                        AppLocalization.of(context).translate('register_screen.lbl_last_name'),
                        value,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Display Name
              TextFormField(
                controller: controller.displayNameController,
                decoration: InputDecoration(
                  hintText: AppLocalization.of(context).translate('register_screen.lbl_display_name'),
                  label: Text(AppLocalization.of(context).translate('register_screen.lbl_display_name')),
                  prefixIcon: Icon(Iconsax.user),
                ),
                validator: (value) => TValidator.validateEmptyText(
                  AppLocalization.of(context).translate('register_screen.lbl_display_name'),
                  value,
                ),
              ),

              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Email
              TextFormField(
                readOnly: true,
                controller: controller.emailController,
                validator: TValidator.validateEmail,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.1),
                  prefixIcon: Icon(Iconsax.direct_right),
                  labelText: AppLocalization.of(context).translate('register_screen.lbl_email'),
                ),
              ),

       
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Email
              TextFormField(
                readOnly: false,
                controller: controller.phoneController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.1),
                    prefixIcon: Icon(Iconsax.direct_right),
                    labelText: AppLocalization.of(context).translate('register_screen.lbl_phone_no'),
                ),
              ),

                const SizedBox(height: TSizes.spaceBtwInputFields),

                Obx(() {
            

                  return DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButtonFormField<int>(
                        isExpanded: true,
                        value: controller.selectedCompanyId.value == 0 ? null : controller.selectedCompanyId.value,
                        onChanged: (value) {
                          controller.selectedCompanyId.value = value ?? 0;
                        },
                        validator: (value) {
                          if (value == null || value == 0) {
                            return AppLocalization.of(context).translate('tab_users_screen.lbl_company_is_required');
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: AppLocalization.of(context).translate('tab_users_screen.lbl_company'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                        ),
                        items: [
                          DropdownMenuItem<int>(
                            value: 0,
                            child: Text(AppLocalization.of(context).translate("tab_users_screen.lbl_company")),
                          ),
                          ...company_controller.allcompanies.map(
                            (company) => DropdownMenuItem<int>(
                              value: company.id,
                              child: Text(company.name!),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                const SizedBox(height: TSizes.spaceBtwInputFields),

                Obx(() {
            

                  return DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButtonFormField<int>(
                        isExpanded: true,
                        value: controller.selectedRoleId.value == 0 ? null : controller.selectedRoleId.value,
                        onChanged: (value) {
                          controller.selectedRoleId.value = value ?? 0;
                        },
                        validator: (value) {
                          if (value == null || value == 0) {
                            return AppLocalization.of(context).translate('tab_users_screen.lbl_role_is_required');
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: AppLocalization.of(context).translate('tab_users_screen.lbl_select_role'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                        ),
                        items: [
                          DropdownMenuItem<int>(
                            value: 0,
                            child: Text(AppLocalization.of(context).translate("tab_users_screen.lbl_select_role")),
                          ),
                          ...controller.userRolesList.map(
                            (role) => DropdownMenuItem<int>(
                              value: role.id,
                              child: Text(role.name),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                const SizedBox(height: TSizes.spaceBtwInputFields),

              // Submit Button
              Obx(() {
                return controller.loading.value
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (controller.formKey.currentState?.validate() ?? false) {
                              if (await controller.updateUserInfo(user)) {
                                    final index = controller.filteredUsers.indexWhere((t) => t.id == user.id);
                                    if (index != -1) {
                                        controller.filteredUsers[index] = user;
                                        controller.filteredUsers.refresh();
                                    }   

                                    }
                              Get.back(result:true);
                            }
                          },
                          child: Text(
                            AppLocalization.of(context).translate('general_msgs.msg_update'),
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