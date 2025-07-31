import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/data/models/object_model.dart';
import 'package:xm_frontend/features/shop/controllers/object/edit_object_controller.dart';
import 'package:xm_frontend/utils/device/device_utility.dart';
import 'package:xm_frontend/utils/helpers/helper_functions.dart';

import '../../../../../../common/widgets/chips/rounded_choice_chips.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/images/image_uploader.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/validators/validation.dart';

class EditObjectForm extends StatelessWidget {
  const EditObjectForm({super.key, required this.object});

  final ObjectModel object;

  @override
  Widget build(BuildContext context) {
    //final controller = Get.put(EditObjectController());
    final controller = Get.find<EditObjectController>();

    controller.init(object);
    return TRoundedContainer(
      width: TDeviceUtils.isDesktopScreen(context) ? 500 : double.infinity,
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            const SizedBox(height: TSizes.sm),
            Text(
              AppLocalization.of(
                context,
              ).translate('edit_object_screen.lbl_update_object'),
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: TSizes.spaceBtwSections),

            Obx(
              () => Center(
                child: TImageUploader(
                  width: 110,
                  height: 110,
                  image:
                      controller.imageURL.value.isNotEmpty
                          ? controller.imageURL.value
                          : TImages.defaultImage,
                  imageType:
                      controller.memoryBytes.value != null
                          ? ImageType.memory
                          : controller.imageURL.value.isNotEmpty
                          ? ImageType.network
                          : ImageType.asset,
                  memoryImage: controller.memoryBytes.value,
                  onIconButtonPressed: () => controller.pickImage(),
                ),
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwSections),

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

            TextFormField(
              controller: controller.street,
              validator:
                  (value) => TValidator.validateEmptyText(
                    AppLocalization.of(
                      context,
                    ).translate('objects_screen.lbl_street'),
                    value,
                  ),
              decoration: InputDecoration(
                labelText: AppLocalization.of(
                  context,
                ).translate('objects_screen.lbl_street'),
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwInputFields),

            TextFormField(
              controller: controller.objectNumber,
              validator:
                  (value) => TValidator.validateEmptyText(
                    AppLocalization.of(
                      context,
                    ).translate('objects_screen.lbl_object_number'),
                    value,
                  ),
              decoration: InputDecoration(
                labelText: AppLocalization.of(
                  context,
                ).translate('objects_screen.lbl_object_number'),
                prefixIcon: Icon(Icons.numbers),
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwInputFields),

            TextFormField(
              controller: controller.zipCode,
              validator:
                  (value) => TValidator.validateEmptyText(
                    AppLocalization.of(
                      context,
                    ).translate('objects_screen.lbl_zip_code'),
                    value,
                  ),
              decoration: InputDecoration(
                labelText: AppLocalization.of(
                  context,
                ).translate('objects_screen.lbl_zip_code'),
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwInputFields),

            TextFormField(
              controller: controller.location,
              validator:
                  (value) => TValidator.validateEmptyText(
                    AppLocalization.of(
                      context,
                    ).translate('objects_screen.lbl_location'),
                    value,
                  ),
              decoration: InputDecoration(
                labelText: AppLocalization.of(
                  context,
                ).translate('objects_screen.lbl_location'),
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
            ),

            // const SizedBox(height: TSizes.spaceBtwInputFields),

            // TextFormField(
            //   readOnly: true,
            //   controller: controller.units,
            //   validator:
            //       (value) => TValidator.validateEmptyText(
            //         AppLocalization.of(
            //           context,
            //         ).translate('buildings_screen.lbl_units'),
            //         value,
            //       ),
            //   decoration: InputDecoration(
            //     filled: true,
            //     fillColor: Colors.grey[100],
            //     labelText: AppLocalization.of(
            //       context,
            //     ).translate('buildings_screen.lbl_units'),
            //     prefixIcon: Icon(Iconsax.category),
            //   ),
            // ),

            // const SizedBox(height: TSizes.spaceBtwInputFields),

            // TextFormField(
            //   readOnly: true,
            //   controller: controller.floors,
            //   validator:
            //       (value) => TValidator.validateEmptyText(
            //         AppLocalization.of(
            //           context,
            //         ).translate('buildings_screen.lbl_floors'),
            //         value,
            //       ),
            //   decoration: InputDecoration(
            //     filled: true,
            //     fillColor: Colors.grey[100],
            //     labelText: AppLocalization.of(
            //       context,
            //     ).translate('buildings_screen.lbl_floors'),
            //     prefixIcon: Icon(Iconsax.category),
            //   ),
            // ),
            const SizedBox(height: TSizes.spaceBtwInputFields * 2),
            Obx(
              () => AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child:
                    controller.loading.value
                        ? const Center(child: CircularProgressIndicator())
                        : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                () => controller.updateObject(object),
                            child: Text(
                              AppLocalization.of(
                                context,
                              ).translate('edit_object_screen.lbl_update'),
                            ),
                          ),
                        ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields * 2),
          ],
        ),
      ),
    );
  }
}
