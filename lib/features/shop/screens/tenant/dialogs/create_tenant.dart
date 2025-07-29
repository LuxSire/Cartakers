import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/features/personalization/models/user_model.dart';
import 'package:xm_frontend/features/shop/controllers/contract/contract_controller.dart';
import 'package:xm_frontend/features/shop/controllers/tenant/tenant_controller.dart';
import 'package:xm_frontend/utils/constants/colors.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/validators/validation.dart';

class CreateTenantDialog extends StatelessWidget {
  const CreateTenantDialog({
    super.key,
    required this.displayBuildings,
    this.buildingId,
  });

  final bool displayBuildings;

  final int? buildingId;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TenantController());
    controller.resetFields();

    if (!displayBuildings) {
      controller.selectedBuildingId.value = buildingId ?? 0;
    } else {
      controller.loadAllBuildings();
    }

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
                    ).translate('tenants_screen.lbl_new_tenant'),
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

                decoration: InputDecoration(
                  prefixIcon: Icon(Iconsax.direct_right),
                  labelText: AppLocalization.of(
                    context,
                  ).translate('register_screen.lbl_email'),
                ),
              ),

              const SizedBox(height: TSizes.spaceBtwInputFields),

              if (displayBuildings == true) ...[
                Obx(() {
                  return DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButtonFormField<int>(
                        isExpanded: true,
                        value:
                            controller.selectedBuildingId.value != 0
                                ? controller.selectedBuildingId.value
                                : null,
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectedBuildingId.value = value;
                          } else {
                            controller.selectedBuildingId.value = 0;
                          }
                        },
                        validator: (value) {
                          if (value == null || value == 0) {
                            return AppLocalization.of(context).translate(
                              'contract_screen.msg_building_required',
                            );
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: AppLocalization.of(
                            context,
                          ).translate('contract_screen.lbl_select_building'),
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
                              AppLocalization.of(context).translate(
                                "contract_screen.lbl_select_building",
                              ),
                            ),
                          ),
                          ...controller.buildingsList.map(
                            (building) => DropdownMenuItem<int>(
                              value: int.parse(building.id!),
                              child: Text(building.name!),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                const SizedBox(height: TSizes.spaceBtwInputFields),
              ],

              /// Submit Button
              Obx(() {
                return controller.loading.value
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.submitTenant,
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
