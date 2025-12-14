import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cartakers/app/localization/app_localization.dart';
import 'package:cartakers/features/shop/controllers/object/edit_object_controller.dart';
import 'package:cartakers/features/shop/controllers/object/object_unit_controller.dart';
import 'package:cartakers/features/shop/controllers/object/object_unit_detail_controller.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/validators/validation.dart';
import 'package:cartakers/features/personalization/controllers/company_controller.dart';
class CreateUnitDialog extends StatelessWidget {
  const CreateUnitDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditObjectController());
    final unitDetailController = Get.find<ObjectUnitDetailController>();
    //controller.resetFields();
    final unitController = Get.put<ObjectUnitController>(ObjectUnitController());

    // Set the unit into controller (only once when screen builds)
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: TRoundedContainer(
        width: 500,
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Form(
          //key: controller.formKey,
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
                    ).translate('objects_screen.lbl_new_unit'),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              const SizedBox(height: TSizes.spaceBtwInputFields),
 
              // Description Text Field
              TextFormField(
                controller: controller.unitdescription,
                validator: (value) => TValidator.validateEmptyText(
                  AppLocalization.of(context).translate('edit_object_screen.lbl_description'),
                  value,
                ),
                minLines: 2,
                maxLines: 10,
                decoration: InputDecoration(
                  labelText: AppLocalization.of(context).translate('edit_object_screen.lbl_description'),
                  prefixIcon: Icon(Iconsax.building),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // TextFormField(
              //   controller: controller.street,
              //   validator:
              //       (value) => TValidator.validateEmptyText(
              //         AppLocalization.of(
              //           context,
              //         ).translate('buildings_screen.lbl_street'),
              //         value,
              //       ),
              //   decoration: InputDecoration(
              //     labelText: AppLocalization.of(
              //       context,
              //     ).translate('buildings_screen.lbl_street'),
              //     prefixIcon: Icon(Icons.location_on_outlined),
              //   ),
              // ),

              // const SizedBox(height: TSizes.spaceBtwInputFields),

              // TextFormField(
              //   controller: controller.buildingNumber,
              //   validator:
              //       (value) => TValidator.validateEmptyText(
              //         AppLocalization.of(
              //           context,
              //         ).translate('buildings_screen.lbl_building_number'),
              //         value,
              //       ),
              //   decoration: InputDecoration(
              //     labelText: AppLocalization.of(
              //       context,
              //     ).translate('buildings_screen.lbl_building_number'),
              //     prefixIcon: Icon(Icons.numbers),
              //   ),
              // ),

              // const SizedBox(height: TSizes.spaceBtwInputFields),


              // const SizedBox(height: TSizes.spaceBtwInputFields),

              // TextFormField(
              //   controller: controller.location,
              //   validator:
              //       (value) => TValidator.validateEmptyText(
              //         AppLocalization.of(
              //           context,
              //         ).translate('buildings_screen.lbl_location'),
              //         value,
              //       ),
              //   decoration: InputDecoration(
              //     labelText: AppLocalization.of(
              //       context,
              //     ).translate('buildings_screen.lbl_location'),
              //     prefixIcon: Icon(Icons.location_on_outlined),
              //   ),
              // ),
              const SizedBox(height: TSizes.spaceBtwInputFields),
              Row(
                children: [
                  // total units
                  Expanded(
                    child: Tooltip(
                      message: AppLocalization.of(
                        context,
                      ).translate('objects_screen.tooltip_total_units'),
                      child: TextFormField(
                        controller: controller.units,
                        decoration: InputDecoration(
                          hintText: AppLocalization.of(
                            context,
                          ).translate('objects_screen.lbl_total_units'),
                          label: Text(
                            AppLocalization.of(
                              context,
                            ).translate('objects_screen.lbl_total_units'),
                          ),
                          prefixIcon: Icon(Icons.numbers),
                        ),
                        validator:
                            (value) => TValidator.validateEmptyText(
                              AppLocalization.of(
                                context,
                              ).translate('objects_screen.lbl_total_units'),
                              value,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwInputFields),
                  // total floors
                  Expanded(
                    child: Tooltip(
                      message: AppLocalization.of(
                        context,
                      ).translate('objects_screen.tooltip_total_floors'),
                      child: TextFormField(
                        controller: controller.floors,
                        decoration: InputDecoration(
                          hintText: AppLocalization.of(
                            context,
                          ).translate('objects_screen.lbl_total_floors'),
                          label: Text(
                            AppLocalization.of(
                              context,
                            ).translate('objects_screen.lbl_total_floors'),
                          ),
                          prefixIcon: Icon(Icons.numbers),
                        ),
                        validator:
                            (value) => TValidator.validateEmptyText(
                              AppLocalization.of(
                                context,
                              ).translate('objects_screen.lbl_total_floors'),
                              value,
                            ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Company Dropdown
              Obx(() {
                final companyController = Get.find<CompanyController>();
                return DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButtonFormField<int>(
                      isExpanded: true,
                      onChanged: (value) {
                        if (controller.selectedCompanyId != null) {
                          controller.selectedCompanyId!.value = value ?? 0;
                        }
                      },
                      validator: (value) {
                        if (value == null || value == 0) {
                          return AppLocalization.of(
                            context,
                          ).translate('companies_screen.lbl_select_company');
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
                        ...companyController.allcompanies.map(
                          (company) => DropdownMenuItem<int>(
                            value: company.id ?? 1,
                            child: Text(company.name),
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
                        onPressed: controller.submitObject,
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
