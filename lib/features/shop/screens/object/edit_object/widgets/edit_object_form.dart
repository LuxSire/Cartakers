import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/data/models/object_model.dart';
import 'package:xm_frontend/features/shop/controllers/object/edit_object_controller.dart';
import 'package:xm_frontend/features/personalization/controllers/user_controller.dart';
import 'package:xm_frontend/features/personalization/controllers/company_controller.dart';
import 'package:xm_frontend/utils/device/device_utility.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/images/image_uploader.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/validators/validation.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat('#,###');

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String digits = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.isEmpty) return newValue.copyWith(text: '');
    final number = int.parse(digits);
    final newString = _formatter.format(number);
    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(offset: newString.length),
    );
  }
}

class EditObjectForm extends StatelessWidget {
  const EditObjectForm({super.key, required this.object});

  final ObjectModel object;


  @override
  Widget build(BuildContext context) 
  {
    final controller = Get.find<EditObjectController>();
    controller.init(object);

    return Obx(() {
      final currentUser = UserController.instance.user.value;
      final canEdit = currentUser != null
          ? currentUser.objectPermissions.any((obj) {
              final objId = obj['id'].toString();
              final objectId = object.id.toString();
              dynamic roleValue = obj['role_'];
              int roleInt;
              if (roleValue is int) {
                roleInt = roleValue;
              } else if (roleValue is String) {
                roleInt = int.tryParse(roleValue) ?? 99;
              } else {
                roleInt = 99;
              }
              return objId == objectId && roleInt < 3;
            })
          : false;

      return TRoundedContainer
      (
        width: double.infinity,
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: LayoutBuilder(
          builder: (context, constraints) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
Row(
  children: [
    Expanded(
      flex: 2,
      child: TextFormField(
        controller: controller.name,
        validator: (value) => TValidator.validateEmptyText(
          AppLocalization.of(context).translate('objects_screen.lbl_object_name'),
          value,
        ),
        style: Theme.of(context).textTheme.headlineLarge,
        decoration: InputDecoration(
          labelText: AppLocalization.of(context).translate('objects_screen.lbl_object_name'),
          prefixIcon: Icon(Iconsax.building),
        ),
        readOnly: !canEdit,
      ),
    ),
    const SizedBox(width: TSizes.spaceBtwInputFields),
    Expanded(
      flex: 2,
      child: Obx(() {
        final companyController = Get.find<CompanyController>();
        final companyItems = companyController.allItems;
        return DropdownButtonFormField<int>(
          value: controller.selectedCompanyId.value != 0
              ? controller.selectedCompanyId.value
              : object.companyId,
          decoration: InputDecoration(
            labelText: AppLocalization.of(context).translate('objects_screen.lbl_owner'),
            prefixIcon: Icon(Icons.person_outline),
            border: const OutlineInputBorder(),
          ),
          items: companyItems
              .map((company) => DropdownMenuItem<int>(
                    value: company.id,
                    child: Text(company.name),
                  ))
              .toList(),
          onChanged: canEdit
              ? (value) {
                  controller.selectedCompanyId.value = value ?? 0;
                }
              : null,
          validator: (value) {
            if (value == null || value == 0) {
              return AppLocalization.of(context).translate('objects_screen.lbl_select_company');
            }
            return null;
          },
        );
      }),
    ),
  ],
),




              const SizedBox(height: TSizes.spaceBtwSections),

              // The rest of the form is scrollable
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: TSizes.spaceBtwSections * 2),

                      // Images carousel
                      Obx(() {
                        if (controller.objectImages.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return SizedBox(
                          height: 500,
                          child: PageView.builder
                          (
                            itemCount: controller.objectImages.length,
                            controller: PageController(viewportFraction: 0.7),
                            itemBuilder: (context, index) {
                              final imageUrl = controller.objectImages[index];
                              return Padding
                              (
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    await launchUrlString(
                                      imageUrl.fileUrl,
                                      mode: LaunchMode.externalApplication,
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      imageUrl.fileUrl,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        color: Colors.grey[200],
                                        child: const Icon(Icons.broken_image, size: 48),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                          )
                        );
                      }),


                      const SizedBox(height: TSizes.spaceBtwInputFields*3),

                      // Occupancy, Zoning, Type dropdowns
                      Row(
                        children: [
                          Expanded(
                            child: Obx(() => DropdownButtonFormField<String>(
                                  value: object.occupancy?.toString().isNotEmpty == true ? object.occupancy?.toString() : null,
                                  decoration: InputDecoration(
                                    labelText: AppLocalization.of(context).translate('objects_screen.lbl_occupancy'),
                                    prefixIcon: Icon(Icons.people_outline),
                                    border: const OutlineInputBorder(),
                                  ),
                                  items: controller.occupancyList
                                      .map((option) => DropdownMenuItem(
                                            value: option,
                                            child: Text(option),
                                          ))
                                      .toList(),
                                  onChanged: canEdit
                                      ? (value) {
                                          controller.occupancy.text = value ?? '';
                                        }
                                      : null,
                                )),
                          ),
                          const SizedBox(width: TSizes.spaceBtwInputFields),
                          Expanded(
                            child: Obx(() => DropdownButtonFormField<String>(
                                  value: object.zoning?.toString().isNotEmpty == true ? object.zoning?.toString() : null,
                                  decoration: InputDecoration(
                                    labelText: AppLocalization.of(context).translate('objects_screen.lbl_zoning'),
                                    prefixIcon: Icon(Icons.map_outlined),
                                    border: const OutlineInputBorder(),
                                  ),
                                  items: controller.zoningList
                                      .map((option) => DropdownMenuItem(
                                            value: option,
                                            child: Text(option),
                                          ))
                                      .toList(),
                                  onChanged: canEdit
                                      ? (value) {
                                          controller.zoning.text = value ?? '';
                                        }
                                      : null,
                                )),
                          ),
                          const SizedBox(width: TSizes.spaceBtwInputFields),
                          Expanded(
                            child: Obx(() => DropdownButtonFormField<String>(
                                  value: object.type_?.toString().isNotEmpty == true ? object.type_?.toString() : null,
                                  decoration: InputDecoration(
                                    labelText: AppLocalization.of(context).translate('objects_screen.lbl_type'),
                                    prefixIcon: Icon(Icons.map_outlined),
                                    border: const OutlineInputBorder(),
                                  ),
                                  items: controller.typeList
                                      .map((option) => DropdownMenuItem(
                                            value: option,
                                            child: Text(option),
                                          ))
                                      .toList(),
                                  onChanged: canEdit
                                      ? (value) {
                                          controller.type_.text = value ?? '';
                                        }
                                      : null,
                                )),
                          ),
                        ],
                      ),



                      const SizedBox(height: TSizes.spaceBtwInputFields * 2),

                      // Information section
                      Text(
                        AppLocalization.of(context).translate('objects_screen.lbl_information'),
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields),

                      // Description
                      TextFormField(
                        controller: controller.description,
                        validator: (value) => TValidator.validateEmptyText(
                          AppLocalization.of(context).translate('objects_screen.lbl_object_description'),
                          value,
                        ),
                        minLines: 2,
                        maxLines: 15,
                        decoration: InputDecoration(
                          labelText: AppLocalization.of(context).translate('objects_screen.lbl_object_description'),
                          prefixIcon: Icon(Iconsax.building),
                        ),
                        readOnly: !canEdit,
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields*2),


                      // Address fields
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: controller.street,
                              validator: (value) => TValidator.validateEmptyText(
                                AppLocalization.of(context).translate('objects_screen.lbl_street'),
                                value,
                              ),
                              decoration: InputDecoration(
                                labelText: AppLocalization.of(context).translate('objects_screen.lbl_street'),
                                prefixIcon: Icon(Icons.location_on_outlined),
                              ),
                              readOnly: !canEdit,
                            ),
                          ),
                          const SizedBox(width: TSizes.spaceBtwInputFields),
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              controller: controller.zipCode,
                              validator: (value) => TValidator.validateEmptyText(
                                AppLocalization.of(context).translate('objects_screen.lbl_zip_code'),
                                value,
                              ),
                              decoration: InputDecoration(
                                labelText: AppLocalization.of(context).translate('objects_screen.lbl_zip_code'),
                                prefixIcon: Icon(Icons.location_on_outlined),
                              ),
                              readOnly: !canEdit,
                            ),
                          ),
                          const SizedBox(width: TSizes.spaceBtwInputFields),
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              controller: controller.city,
                              validator: (value) => TValidator.validateEmptyText(
                                AppLocalization.of(context).translate('objects_screen.lbl_city'),
                                value,
                              ),
                              decoration: InputDecoration(
                                labelText: AppLocalization.of(context).translate('objects_screen.lbl_city'),
                                prefixIcon: Icon(Icons.location_city),
                              ),
                              readOnly: !canEdit,
                            ),
                          ),
                          const SizedBox(width: TSizes.spaceBtwInputFields),
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              controller: controller.country,
                              validator: (value) => TValidator.validateEmptyText(
                                AppLocalization.of(context).translate('objects_screen.lbl_country'),
                                value,
                              ),
                              decoration: InputDecoration(
                                labelText: AppLocalization.of(context).translate('objects_screen.lbl_country'),
                                prefixIcon: Icon(Icons.waves),
                              ),
                              readOnly: !canEdit,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields),

                      const SizedBox(height: TSizes.spaceBtwInputFields),

                      // Floors and Units
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: controller.floors,
                              validator: (value) => TValidator.validateEmptyText(
                                AppLocalization.of(context).translate('objects_screen.lbl_floors'),
                                value,
                              ),
                              decoration: InputDecoration(
                                labelText: AppLocalization.of(context).translate('objects_screen.lbl_floors'),
                                prefixIcon: Icon(Icons.location_on_outlined),
                              ),
                              readOnly: !canEdit,
                            ),
                          ),
                          const SizedBox(width: TSizes.spaceBtwInputFields),
                          Expanded(
                            child: TextFormField(
                              controller: controller.units,
                              validator: (value) => TValidator.validateEmptyText(
                                AppLocalization.of(context).translate('objects_screen.lbl_units'),
                                value,
                              ),
                              decoration: InputDecoration(
                                labelText: AppLocalization.of(context).translate('objects_screen.lbl_units'),
                                prefixIcon: Icon(Icons.location_on_sharp),
                              ),
                              readOnly: !canEdit,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: TSizes.spaceBtwInputFields * 2),

                      // Financials section
                      Text(
                        AppLocalization.of(context).translate('objects_screen.lbl_financials'),
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields),

                      // Price, Currency, YieldNet, YieldGross
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: controller.price,
                              validator: (value) => TValidator.validateEmptyText(
                                AppLocalization.of(context).translate('objects_screen.lbl_price'),
                                value,
                              ),
                              decoration: InputDecoration(
                                labelText: AppLocalization.of(context).translate('objects_screen.lbl_price'),
                                prefixIcon: Icon(Icons.money),
                              ),
                              readOnly: !canEdit,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                  ThousandsSeparatorInputFormatter(),
                                  ],
                            ),
                          ),
                          const SizedBox(width: TSizes.spaceBtwInputFields),
                          Expanded(
                            child: TextFormField(
                              initialValue: object.currency ?? '',
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: AppLocalization.of(context).translate('objects_screen.lbl_currency'),
                                prefixIcon: Icon(Icons.attach_money),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: controller.yieldNet,
                              validator: (value) => TValidator.validateEmptyText(
                                AppLocalization.of(context).translate('objects_screen.lbl_yieldnet'),
                                value,
                              ),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: InputDecoration(
                                labelText: AppLocalization.of(context).translate('objects_screen.lbl_yieldnet'),
                                prefixIcon:Icon(Icons.money),
                                suffixText: '%',
                              ),
                              readOnly: !canEdit,
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: controller.yieldGross,
                              validator: (value) => TValidator.validateEmptyText(
                                AppLocalization.of(context).translate('objects_screen.lbl_yieldgross'),
                                value,
                              ),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: InputDecoration(
                                labelText: AppLocalization.of(context).translate('objects_screen.lbl_yieldgross'),
                                prefixIcon: Icon(Icons.money),
                                suffixText: '%',
                              ),
                              readOnly: !canEdit,
                            ),
                          ),
                              Expanded(
                            child: TextFormField(
                              controller: controller.noi,
                              validator: (value) => TValidator.validateEmptyText(
                                AppLocalization.of(context).translate('objects_screen.lbl_noi'),
                                value,
                              ),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: InputDecoration(
                                labelText: AppLocalization.of(context).translate('objects_screen.lbl_noi'),
                                prefixIcon: Icon(Icons.money),
                                suffixText: '%',
                              ),
                              readOnly: !canEdit,
                            ),
                          ),
                              Expanded(
                            child: TextFormField(
                              controller: controller.caprate,
                              validator: (value) => TValidator.validateEmptyText(
                                AppLocalization.of(context).translate('objects_screen.lbl_caprate'),
                                value,
                              ),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: InputDecoration(
                                labelText: AppLocalization.of(context).translate('objects_screen.lbl_caprate'),
                                prefixIcon: Icon(Icons.money),
                                suffixText: '%',
                              ),
                              readOnly: !canEdit,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields * 2),

                      // Image uploader
                      Center(
                        child: TImageUploader(
                          width: 110,
                          height: 220,
                          image: controller.imageURL.value.isNotEmpty
                              ? controller.imageURL.value
                              : TImages.defaultImage,
                          imageType: controller.memoryBytes.value != null
                              ? ImageType.memory
                              : controller.imageURL.value.isNotEmpty
                                  ? ImageType.network
                                  : ImageType.asset,
                          memoryImage: controller.memoryBytes.value,
                          onIconButtonPressed: () => controller.pickImage(object),
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections),

                      // Submit button
                      if (canEdit)
                      Obx(() {
                        return AnimatedSwitcher(
                          duration: const Duration(seconds: 1),
                          child: controller.loading.value
                              ? const Center(child: CircularProgressIndicator())
                              : Center(
                                  child: SizedBox(
                                    width: TDeviceUtils.isDesktopScreen(context)
                                        ? MediaQuery.of(context).size.width * 0.5
                                        : double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 24),
                                        textStyle: Theme.of(context).textTheme.headlineSmall,
                                      ),
                                      onPressed: canEdit ? () => controller.updateObject(object) : null,
                                      child: Text(
                                        AppLocalization.of(context)
                                            .translate('edit_object_screen.lbl_update'),
                                      ),
                                    ),
                                  ),
                                ),
                        );
                      }),
                      const SizedBox(height: TSizes.spaceBtwInputFields * 2),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
