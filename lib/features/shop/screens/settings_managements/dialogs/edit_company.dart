import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/common/widgets/chips/rounded_choice_chips.dart';
import 'package:xm_frontend/common/widgets/images/image_uploader.dart';
import 'package:xm_frontend/features/personalization/controllers/company_controller.dart';
import 'package:xm_frontend/features/personalization/models/user_model.dart';
import 'package:xm_frontend/features/shop/controllers/contract/permission_controller.dart';
//import 'package:xm_frontend/features/shop/controllers/user/user_controller.dart';
import 'package:xm_frontend/utils/constants/colors.dart';
import 'package:xm_frontend/utils/constants/enums.dart';
import 'package:xm_frontend/utils/constants/image_strings.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/validators/validation.dart';

class EditCompanyDialog extends StatelessWidget {
  const EditCompanyDialog({super.key, required this.showExtraFields});

  final bool showExtraFields;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CompanyController>();
    controller.emailController.text = controller.company.value.email ?? '';
    controller.nameController.text = controller.company.value.name ?? '';
    controller.displayNameController.text =
        controller.company.value.displayName ?? '';

        
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
                  image: controller.companyRetrivedProfileUrl.value.isNotEmpty
                      ? controller.companyRetrivedProfileUrl.value
                      : TImages.user,
                  imageType: controller.memoryBytes.value != null
                      ? ImageType.memory
                      : controller.companyRetrivedProfileUrl.value.isNotEmpty
                          ? ImageType.network
                          : ImageType.asset,
                  memoryImage: controller.memoryBytes.value,
                  onIconButtonPressed: () => controller.pickImage(),
                ),
              )),

              const SizedBox(height: TSizes.spaceBtwSections),

              // Name
              TextFormField(
                controller: controller.nameController,
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

              // Role selection (if admin)
              if (controller.company.value.roleExtId == 1) ...[
                Obx(() {
                  final allowedIds = [0, ...controller.companyRolesList.map((role) => role.id)];
                  final currentValue = allowedIds.contains(controller.selectedRoleId.value)
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
                            return AppLocalization.of(context).translate('tab_users_screen.lbl_role_is_required');
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: AppLocalization.of(context).translate('tab_users_screen.lbl_select_role'),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        ),
                        items: [
                          DropdownMenuItem<int>(
                            value: 0,
                            child: Text(AppLocalization.of(context).translate("tab_users_screen.lbl_select_role")),
                          ),
                          ...controller.companyRolesList.map((role) => DropdownMenuItem<int>(
                            value: role.id,
                            child: Text(role.nameTranslated!),
                          )),
                        ],
                      ),
                    ),
                  );
                }),

                const SizedBox(height: TSizes.spaceBtwInputFields),

                Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalization.of(context).translate('tab_users_screen.lbl_object_permission'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: TSizes.sm,
                      runSpacing: TSizes.sm,
                      children: controller.objectsList.map((object) {
                        final selected = controller.selectedObjectIds.contains(object.id!);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: TSizes.sm),
                          child: TChoiceChip(
                            text: object.name ?? '',
                            selected: selected,
                            onSelected: (_) => controller.toggleObject(object.id!),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                )),
              ],

              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Submit Button
              Obx(() {
                return controller.loading.value
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // controller.updateCompanyInformation();
                          },
                          child: Text(AppLocalization.of(context).translate('general_msgs.msg_update')),
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
