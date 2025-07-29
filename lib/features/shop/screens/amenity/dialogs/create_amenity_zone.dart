import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/features/shop/controllers/amenity/amenity_controller.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/validators/validation.dart';

class CreateAmenityZoneDialog extends StatelessWidget {
  const CreateAmenityZoneDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AmenityAssignmentController.instance;
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
                    ).translate('amenity_zone_screen.lbl_new_amenity_zone'),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Amenity Zone Name
              TextFormField(
                controller: controller.amenityZoneNameController,
                validator:
                    (value) => TValidator.validateEmptyText(
                      AppLocalization.of(
                        context,
                      ).translate('amenity_zone_screen.lbl_amenity_zone_name'),
                      value,
                    ),

                decoration: InputDecoration(
                  prefixIcon: Icon(Iconsax.square),
                  labelText: AppLocalization.of(
                    context,
                  ).translate('amenity_zone_screen.lbl_amenity_zone_name'),
                ),
              ),

              const SizedBox(height: TSizes.spaceBtwInputFields),

              /// Submit Button
              Obx(() {
                return controller.loading.value
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.submitNewAmenityZone,
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
