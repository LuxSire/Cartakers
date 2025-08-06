import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/data/models/object_model.dart';
//import 'package:xm_frontend/features/personalization/models/user_model.dart';
import 'package:xm_frontend/features/shop/controllers/object/edit_object_controller.dart';
import 'package:xm_frontend/features/personalization/controllers/user_controller.dart';
import 'package:xm_frontend/utils/device/device_utility.dart';
//import 'package:xm_frontend/utils/helpers/helper_functions.dart';

//import 'package:xm_frontend/data/repositories/authentication/authentication_repository.dart';
import 'package:url_launcher/url_launcher_string.dart';
//import '../../../../../../common/widgets/chips/rounded_choice_chips.dart';
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
    debugPrint('EditObjectForm build called for object: ${object.id}');

    final controller = Get.find<EditObjectController>();

    controller.init(object);
    return Obx(() {
      final currentUser = UserController.instance.user.value;
      debugPrint('Current user: ${currentUser?.id}, Permissions: ${currentUser?.objectPermissions}'); 
      final canEdit = currentUser != null
        ? currentUser.objectPermissions.any((obj) {
            final objId = obj['id'].toString();
            final objectId = this.object.id.toString();
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
      debugPrint('Can edit: $canEdit');

      return TRoundedContainer(
        width: double.infinity,
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
              Center(
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
              const SizedBox(height: TSizes.spaceBtwSections),
              // Name Text Field
              TextFormField(
                controller: controller.name,
                validator: (value) => TValidator.validateEmptyText(
                  AppLocalization.of(context).translate('objects_screen.lbl_object_name'),
                  value,
                ),
                decoration: InputDecoration(
                  labelText: AppLocalization.of(context).translate('objects_screen.lbl_object_name'),
                  prefixIcon: Icon(Iconsax.building),
                ),
              ),
              Obx(() {
                if (controller.objectImages.isEmpty) {
                  return const SizedBox.shrink();
                }
                return SizedBox(
                  height: 140,
                  child: PageView.builder(
                    itemCount: controller.objectImages.length,
                    controller: PageController(viewportFraction: 0.7),
                    itemBuilder: (context, index) {
                      final imageUrl = controller.objectImages[index];
                      return Padding(
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
                    },
                  ),
                );
              }),
              const SizedBox(height: TSizes.spaceBtwInputFields),
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
                readOnly: !canEdit,
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),
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
              TextFormField(
                initialValue: object.owner?.toString() ?? '',
                readOnly: canEdit ? false : true,
                decoration: InputDecoration(
                  labelText: AppLocalization.of(context).translate('objects_screen.lbl_owner'),
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),
              Row(
                children: [
                  Expanded(
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
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwInputFields),
                  Expanded(
                    child: TextFormField(
                      initialValue: object.city ?? '',
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: AppLocalization.of(context).translate('objects_screen.lbl_city'),
                        prefixIcon: Icon(Icons.location_city),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),
              TextFormField(
                controller: controller.location,
                validator: (value) => TValidator.validateEmptyText(
                  AppLocalization.of(context).translate('objects_screen.lbl_location'),
                  value,
                ),
                decoration: InputDecoration(
                  labelText: AppLocalization.of(context).translate('objects_screen.lbl_location'),
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),
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
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields * 2),
              // Occupancy, Zoning, Type_
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: object.occupancy?.toString() ?? '',
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: AppLocalization.of(context).translate('objects_screen.lbl_occupancy'),
                        prefixIcon: Icon(Icons.people_outline),
                      ),
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwInputFields),
                  Expanded(
                    child: TextFormField(
                      initialValue: object.zoning ?? '',
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: AppLocalization.of(context).translate('objects_screen.lbl_zoning'),
                        prefixIcon: Icon(Icons.map_outlined),
                      ),
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwInputFields),
                  Expanded(
                    child: TextFormField(
                      initialValue: object.type_ ?? '',
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: AppLocalization.of(context).translate('objects_screen.lbl_type'),
                        prefixIcon: Icon(Icons.category_outlined),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields * 2),
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
                              onPressed: canEdit == true ? () => controller.updateObject(object) : null,
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
      );
    });
  }
}