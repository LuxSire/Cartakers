import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/common/widgets/chips/rounded_choice_chips.dart';
import 'package:xm_frontend/common/widgets/containers/rounded_container.dart';
import 'package:xm_frontend/features/shop/controllers/amenity/amenity_controller.dart';
import 'package:xm_frontend/features/shop/screens/amenity/dialogs/create_amenity_zone.dart';
import 'package:xm_frontend/utils/constants/colors.dart';
import 'package:xm_frontend/utils/constants/sizes.dart';
import 'package:xm_frontend/utils/device/device_utility.dart';

class AssignAmenityZoneDialog extends StatelessWidget {
  final int objectId;

  const AssignAmenityZoneDialog({super.key, required this.objectId});

  @override
  Widget build(BuildContext context) {
    debugPrint('AssignAmenityZoneDialog: objectId: $objectId');

    final controller = Get.find<AmenityAssignmentController>();

    controller.loadData();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: TRoundedContainer(
        width: 700,
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Obx(() {
          if (controller.loading.value) {
            return const SizedBox(
              height: 300,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final grouped = controller.getUnitsGroupedByFloor();

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalization.of(
                      context,
                    ).translate('amenity_zone_screen.lbl_assign_amenity_zone'),
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
                  Expanded(
                    flex: !TDeviceUtils.isDesktopScreen(context) ? 1 : 3,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 300,
                          child: DropdownButtonFormField<int>(
                            value: controller.selectedZoneId.value,
                            items:
                                controller.zones
                                    .map(
                                      (z) => DropdownMenuItem(
                                        value: z.id,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [Text(z.name)],
                                        ),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (val) {
                              if (val != null) controller.setSelectedZone(val);
                            },
                            decoration: InputDecoration(
                              labelText: AppLocalization.of(context).translate(
                                'amenity_zone_screen.lbl_amenity_zones',
                              ),
                              prefixIcon: Icon(Iconsax.square),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: TDeviceUtils.isDesktopScreen(context) ? 3 : 1,
                    child: TextButton.icon(
                      onPressed: () async {
                        final result = await showDialog<bool>(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return const CreateAmenityZoneDialog();
                          },
                        );

                        if (result == true) {
                          controller.loadZones(); //
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: Text(
                        AppLocalization.of(context).translate(
                          'amenity_zone_screen.lbl_create_new_amenity_zone',
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: TSizes.spaceBtwInputFields),

              /// Search
              TextFormField(
                controller: controller.searchController,
                onChanged: controller.filterUnits,
                decoration: InputDecoration(
                  labelText: AppLocalization.of(
                    context,
                  ).translate('amenity_zone_screen.lbl_search_units'),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              /// Unit Chips Grouped by Floor
              SizedBox(
                height: 400, // or use MediaQuery to adapt dynamically
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        grouped.entries.map((entry) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${AppLocalization.of(context).translate('dashboard_screen.lbl_floor')} ${entry.key}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: TSizes.sm,
                                children:
                                    entry.value.map((unit) {
                                      final selected = controller
                                          .selectedUnitIds
                                          .contains(int.parse(unit.id!));
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: TSizes.sm,
                                        ),
                                        child: TChoiceChip(
                                          text: unit.unitNumber ?? '',
                                          selected: selected,
                                          onSelected:
                                              (_) => controller.toggleUnit(
                                                int.parse(unit.id!),
                                              ),
                                        ),
                                      );
                                    }).toList(),
                              ),
                              const SizedBox(height: TSizes.spaceBtwItems),
                            ],
                          );
                        }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: TSizes.spaceBtwSections),

              /// Assign Button
              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton(
              //     onPressed: () async {
              //       final success = await controller.assignUnitsToZone();
              //       if (success) Get.back(result: true);
              //     },
              //     child: const Text('Assign'),
              //   ),
              // ),
              SizedBox(
                width: double.infinity,
                child: Obx(() {
                  return controller.loading.value
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            // final success =
                            await controller.assignUnitsToZone();
                            //  if (success) Get.back(result: true);
                          },
                          child: Text(
                            AppLocalization.of(
                              context,
                            ).translate('general_msgs.msg_update'),
                          ),
                        ),
                      );
                }),
              ),
            ],
          );
        }),
      ),
    );
  }
}
