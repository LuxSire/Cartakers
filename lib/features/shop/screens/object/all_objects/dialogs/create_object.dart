import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/features/shop/controllers/object/edit_object_controller.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/validators/validation.dart';
import 'package:xm_frontend/features/personalization/controllers/company_controller.dart';

class CreateObjectDialog extends StatelessWidget {
  const CreateObjectDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditObjectController());
    controller.resetFields();

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
                    ).translate('objects_screen.lbl_new_object'),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Name Text Field
              TextFormField(
                controller: controller.name,
                validator:
                    (value) => TValidator.validateEmptyText(
                      AppLocalization.of(
                        context,
                      ).translate('objects_screen.lbl_object_name'),
                      value,
                    ),
                decoration: InputDecoration(
                  labelText: AppLocalization.of(
                    context,
                  ).translate('objects_screen.lbl_object_name'),
                  prefixIcon: Icon(Iconsax.building),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // City Text Field
              TextFormField(
                controller: controller.city,
                validator: (value) => TValidator.validateEmptyText(
                  AppLocalization.of(context).translate('objects_screen.lbl_city'),
                  value,
                ),
                decoration: InputDecoration(
                  labelText: AppLocalization.of(context).translate('objects_screen.lbl_city'),
                  prefixIcon: Icon(Icons.location_city),
                ),
              ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),
              // Region Text Field
              TextFormField(
                controller: controller.state,
                validator: (value) => TValidator.validateEmptyText(
                  AppLocalization.of(context).translate('objects_screen.lbl_state'),
                  value,
                ),
                decoration: InputDecoration(
                  labelText: AppLocalization.of(context).translate('objects_screen.lbl_state'),
                  prefixIcon: Icon(Icons.location_city),
                ),  
                ),

                  const SizedBox(height: TSizes.spaceBtwInputFields),

              // Country Text Field
              // ...inside your Column children...

// Country Autocomplete Field
Autocomplete<String>(
  optionsBuilder: (TextEditingValue textEditingValue) {
    if (textEditingValue.text == '') {
      return const Iterable<String>.empty();
    }
    return controller.countryList.where((String option) {
      return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
    });
  },
  onSelected: (String selection) {
    controller.country.text = selection;
  },
  fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
    // Sync the controller's text with the Autocomplete's text controller
    textEditingController.text = controller.country.text;
    textEditingController.selection = TextSelection.fromPosition(
      TextPosition(offset: textEditingController.text.length),
    );
    return TextFormField(
      controller: textEditingController,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: AppLocalization.of(context).translate('objects_screen.lbl_country'),
        prefixIcon: Icon(Icons.location_city),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalization.of(context).translate('objects_screen.lbl_country');
        }
        if (!controller.countryList.contains(value)) {
          return AppLocalization.of(context).translate('objects_screen.lbl_country_invalid');
        }
        return null;
      },
      onChanged: (value) {
        controller.country.text = value;
      },
    );
  },
),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Price Text Field
              TextFormField(
                controller: controller.price,
                validator: (value) => TValidator.validateEmptyText(
                  AppLocalization.of(context).translate('objects_screen.lbl_price'),
                  value,
                ),
                decoration: InputDecoration(
                  labelText: AppLocalization.of(context).translate('objects_screen.lbl_price'),
                  prefixIcon: Icon(Icons.money),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Street Text Field
              TextFormField(
                controller: controller.street,
                validator: (value) => TValidator.validateEmptyText(
                  AppLocalization.of(context).translate('objects_screen.lbl_street'),
                  value,
                ),
                decoration: InputDecoration(
                  labelText: AppLocalization.of(context).translate('objects_screen.lbl_street'),
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Zip Code Text Field
              TextFormField(
                controller: controller.zipCode,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return AppLocalization.of(context).translate('objects_screen.lbl_zip_code');
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return AppLocalization.of(context).translate('objects_screen.lbl_zip_code');
    }
    if (value.length > 5) {
      return AppLocalization.of(context).translate('objects_screen.lbl_zip_code');
    }
    return null;
  },
  maxLength: 5,
  keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: AppLocalization.of(context).translate('objects_screen.lbl_zip_code'),
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Description Text Field
              TextFormField(
                controller: controller.description,
                validator: (value) => TValidator.validateEmptyText(
                  AppLocalization.of(context).translate('objects_screen.lbl_object_description'),
                  value,
                ),
                minLines: 2,
                maxLines: 10,
                decoration: InputDecoration(
                  labelText: AppLocalization.of(context).translate('objects_screen.lbl_object_description'),
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
