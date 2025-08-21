import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/common/widgets/chips/rounded_choice_chips.dart';
import 'package:xm_frontend/features/personalization/controllers/user_controller.dart';
import 'package:xm_frontend/features/personalization/controllers/company_controller.dart';
import 'package:xm_frontend/features/personalization/models/user_model.dart';
import 'package:xm_frontend/features/shop/controllers/contract/permission_controller.dart';
//import 'package:xm_frontend/features/shop/controllers/user/user_controller.dart';
import 'package:xm_frontend/utils/constants/colors.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/validators/validation.dart';

class CreateUserDialog extends StatelessWidget {
  const CreateUserDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserController>();
    final companyController = Get.find<CompanyController>();
    controller.resetUserDetails();

    companyController.loadAllObjects();
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

              Obx(() {
                // Only allow value if present in the list or if 0
                final allowedIds = [
                  0,
                  ...controller.userRolesList.map((role) => role.id),
                ];
                final currentValue =
                    allowedIds.contains(controller.selectedRoleId.value)
                        ? controller.selectedRoleId.value
                        : 0;

                return DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButtonFormField<int>(
                      isExpanded: true,
                      value: currentValue == 0 ? null : currentValue,
                      onChanged: (value) {
                        controller.selectedRoleId.value = value ?? 0;
                      },
                      validator: (value) {
                        if (value == null || value == 0) {
                          return AppLocalization.of(
                            context,
                          ).translate('tab_users_screen.lbl_role_is_required');
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: AppLocalization.of(
                          context,
                        ).translate('tab_users_screen.lbl_select_role'),
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
                          child: Text(
                            AppLocalization.of(
                              context,
                            ).translate("tab_users_screen.lbl_select_role"),
                          ),
                        ),
                        ...controller.userRolesList.map(
                          (role) => DropdownMenuItem<int>(
                            value: role.id,
                            child: Text(role.nameTranslated!),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Company Dropdown
              Obx(() {
                final companyController =   Get.find<CompanyController>();
                final allowedCompanyIds = [
                  0,
                  ...companyController.allItems.map((company) => int.tryParse(company.id.toString()) ?? 0),
                ];
                final currentCompanyValue = allowedCompanyIds.contains(controller.selectedObjectId.value)
                    ? controller.selectedObjectId.value
                    : 0;

                return DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButtonFormField<int>(
                      isExpanded: true,
                      value: currentCompanyValue == 0 ? null : currentCompanyValue,
                      onChanged: (value) {
                        controller.selectedObjectId.value = value ?? 0;
                      },
                      validator: (value) {
                        if (value == null || value == 0) {
                          return AppLocalization.of(
                            context,
                          ).translate('contract_screen.msg_object_required');
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: AppLocalization.of(
                          context,
                        ).translate('companies_screen.lbl_select_company'),
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
                          child: Text(
                            AppLocalization.of(
                              context,
                            ).translate("companies_screen.lbl_select_company"),
                          ),
                        ),
                        ...companyController.allItems.map(
                          (company) => DropdownMenuItem<int>(
                            value: int.tryParse(company.id.toString()) ?? 0,
                            child: Text(company.name ?? ''),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

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
                          ).translate('general_msgs.msg_add'),
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
