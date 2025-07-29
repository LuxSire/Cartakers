import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/features/personalization/models/user_model.dart';
import 'package:xm_frontend/features/shop/controllers/contract/contract_controller.dart';
import 'package:xm_frontend/features/shop/screens/tenant/dialogs/create_tenant.dart';
import 'package:xm_frontend/utils/constants/colors.dart';
import 'package:xm_frontend/utils/popups/loaders.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/validators/validation.dart';

class CreateContractDialog extends StatelessWidget {
  const CreateContractDialog({
    super.key,
    required this.displayUniits,
    this.unitId,
    required this.buildingId,
  });

  final bool? displayUniits;
  // for when create a contract from assign screen
  final int? unitId;
  final int buildingId;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ContractController());
    controller.contractReferenceController.clear();
    controller.startDateController.clear();
    controller.selectedTenants.value = [];
    controller.tenants.value = [];
    controller.selectedUnitId.value = 0;
    controller.selectedBuildingId.value = 0;
    controller.loadSelectedBuildingNonContractTenants(buildingId);
    controller.loadAllBuildings();

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
                    ).translate('create_contract_screen.lbl_new_contract'),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Contract Reference
              TextFormField(
                controller: controller.contractReferenceController,
                decoration: InputDecoration(
                  labelText: AppLocalization.of(
                    context,
                  ).translate('unit_detail_screen.lbl_contract_reference'),
                  prefixIcon: Icon(Icons.description),
                ),
                validator:
                    (value) => TValidator.validateEmptyText(
                      AppLocalization.of(
                        context,
                      ).translate('unit_detail_screen.lbl_contract_reference'),
                      value,
                    ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              /// Start Date
              TextFormField(
                controller: controller.startDateController,

                readOnly: true,
                onTap: () => controller.pickStartDate(context),
                decoration: InputDecoration(
                  labelText: AppLocalization.of(
                    context,
                  ).translate('create_contract_screen.lbl_start_date'),
                  prefixIcon: Icon(Icons.date_range),
                ),
                validator:
                    (value) => TValidator.validateEmptyText(
                      AppLocalization.of(
                        context,
                      ).translate('create_contract_screen.lbl_start_date'),
                      value,
                    ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // display units, add drop down
              if (displayUniits == true) ...[
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
                            controller.loadAllBuildingUnits(value);
                            controller.loadNonContractTenants(value);
                            controller.selectedUnitId.value =
                                0; // Reset unit selection
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

                Obx(() {
                  return DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButtonFormField<int>(
                        isExpanded: true,
                        value:
                            controller.selectedUnitId.value != 0
                                ? controller.selectedUnitId.value
                                : null,
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectedUnitId.value = value;
                          }
                        },
                        validator: (value) {
                          if (value == null || value == 0) {
                            return AppLocalization.of(
                              context,
                            ).translate('contract_screen.msg_unit_required');
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: AppLocalization.of(
                            context,
                          ).translate('contract_screen.lbl_select_unit'),
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
                              ).translate("contract_screen.lbl_select_unit"),
                            ),
                          ),
                          ...controller.unitsList.map(
                            (unit) => DropdownMenuItem<int>(
                              value: int.parse(unit.id!),
                              child: Text(unit.unitNumber!),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],

              const SizedBox(height: TSizes.spaceBtwInputFields),

              /// Multi-select Tenants
              /// Multi-select Tenants (inside Form)
              Obx(() {
                return Theme(
                  data: Theme.of(context).copyWith(
                    primaryColor: TColors.primary,
                    dialogBackgroundColor:
                        Theme.of(context).dialogBackgroundColor,
                    checkboxTheme: CheckboxThemeData(
                      fillColor: MaterialStateProperty.all(TColors.primary),
                    ),
                  ),
                  child: MultiSelectDialogField<UserModel>(
                    title: Text(
                      AppLocalization.of(
                        context,
                      ).translate('create_contract_screen.lbl_select_tenants'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    buttonText: Text(
                      AppLocalization.of(
                        context,
                      ).translate('create_contract_screen.lbl_select_tenants'),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    separateSelectedItems: true,
                    searchable: true,
                    listType: MultiSelectListType.LIST,
                    selectedColor: TColors.primary, // Checkboxes color
                    itemsTextStyle: Theme.of(context).textTheme.bodyLarge,
                    dialogHeight: 500,
                    dialogWidth: 600, // Optional for desktop

                    items:
                        controller.tenants
                            .map(
                              (t) => MultiSelectItem<UserModel>(
                                t,
                                '${t.displayName}\n${t.email}',
                              ),
                            )
                            .toList(),
                    initialValue: controller.selectedTenants,
                    onConfirm: (values) {
                      controller.selectedTenants.value = values;
                    },
                    chipDisplay: MultiSelectChipDisplay(
                      chipColor: TColors.primary.withOpacity(0.1),
                      textStyle: Theme.of(context).textTheme.bodyMedium,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      items:
                          controller.selectedTenants
                              .map(
                                (t) => MultiSelectItem<UserModel>(
                                  t,
                                  t.displayName,
                                ),
                              )
                              .toList(),
                    ),
                    // validator: (values) {
                    //   if (values == null || values.isEmpty) {
                    //     return 'Please select at least one tenant';
                    //   }
                    //   return null;
                    // },
                  ),
                );
              }),

              const SizedBox(height: TSizes.spaceBtwInputFields * 2),

              /// Actions
              Row(
                children: [
                  Expanded(
                    child:
                    /// Submit Button
                    Obx(() {
                      return controller.loading.value
                          ? const Center(child: CircularProgressIndicator())
                          : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (unitId != null) {
                                  controller.submitContractFromUnitAssign(
                                    unitId!,
                                    buildingId ?? 0,
                                  );
                                } else {
                                  controller.submitContract();
                                }
                              },
                              child: Text(
                                AppLocalization.of(
                                  context,
                                ).translate('general_msgs.msg_add'),
                              ),
                            ),
                          );
                    }),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),

                  Expanded(
                    child: TextButton.icon(
                      onPressed: () async {
                        bool useSelectedBuilding = false;

                        if (displayUniits == true) {
                          useSelectedBuilding = true;
                          if (controller.selectedBuildingId.value == 0) {
                            TLoaders.errorSnackBar(
                              title: AppLocalization.of(
                                Get.context!,
                              ).translate('general_msgs.msg_error'),
                              message: AppLocalization.of(
                                Get.context!,
                              ).translate(
                                'contract_screen.lbl_please_select_a_building',
                              ),
                            );

                            return;
                          }
                        }

                        final result = await showDialog<bool>(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return CreateTenantDialog(
                              displayBuildings: false,
                              buildingId:
                                  useSelectedBuilding
                                      ? controller.selectedBuildingId.value
                                      : buildingId,
                            );
                          },
                        );

                        // If the tenant was created (e.g., result == true), reload the list

                        debugPrint('CreateTenantDialog result: $result');
                        if (result!) {
                          debugPrint('CreateTenantDialog result 2: $result');
                          controller.loadNonContractTenants(
                            useSelectedBuilding
                                ? controller.selectedBuildingId.value
                                : buildingId,
                          ); //
                        }
                      },

                      icon: const Icon(Icons.person_add),
                      label: Text(
                        AppLocalization.of(
                          context,
                        ).translate('tenants_screen.lbl_create_new_tenant'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
