import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/data/models/object_model.dart';
import 'package:xm_frontend/features/shop/controllers/amenity/amenity_controller.dart';
import 'package:xm_frontend/features/shop/controllers/object/object_unit_detail_controller.dart';
import 'package:xm_frontend/features/shop/controllers/object/edit_object_controller.dart';
import 'package:xm_frontend/features/shop/screens/amenity/dialogs/assign_amenity_zone.dart';
import 'package:xm_frontend/utils/constants/colors.dart';

class ObjectUnitsTableHeader extends StatelessWidget {
  const ObjectUnitsTableHeader({super.key, required this.object});

  final ObjectModel object;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ObjectUnitDetailController());

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;

        if (isSmallScreen) {
          // Stack vertically
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextButton.icon(
                onPressed: () async {
                  final controllerAssign = Get.put(
                    AmenityAssignmentController(),
                  );

                  controllerAssign.objectId.value = int.parse(object.id!);

                  controllerAssign.loadData();

                  final result = await showDialog<bool>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AssignAmenityZoneDialog(
                        objectId: int.parse(object.id!),
                      );
                    },
                  );
                  if (result == true) {
                    controller.getUsersOfCurrentUnit();
                  }
                },
                icon: const Icon(
                  Iconsax.tick_circle,
                  color: TColors.alterColor,
                ),
                label: Text(
                  AppLocalization.of(
                    context,
                  ).translate('edit_object_screen.lbl_assign_amenity_zone'),
                  style: const TextStyle(color: TColors.alterColor),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.searchTextController,
                onChanged: (query) => controller.searchQuery(query),
                decoration: InputDecoration(
                  hintText: AppLocalization.of(
                    context,
                  ).translate('edit_object_screen.lbl_search_units'),
                  prefixIcon: const Icon(Iconsax.search_normal),
                ),
              ),
            ],
          );
        } else {
          // Side by side
          return Row(
            children: [
              TextButton.icon(
                onPressed: () async {
                  final controllerAssign = Get.put(
                    AmenityAssignmentController(),
                  );

                  controllerAssign.objectId.value = int.parse(object.id!);

                  controllerAssign.loadData();

                  final result = await showDialog<bool>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AssignAmenityZoneDialog(
                        objectId: int.parse(object.id!),
                      );
                    },
                  );
                  if (result == true) {
                    controller.getUsersOfCurrentUnit();
                  }
                },
                icon: const Icon(
                  Iconsax.tick_circle,
                  color: TColors.alterColor,
                ),
                label: Text(
                  AppLocalization.of(
                    context,
                  ).translate('edit_object_screen.lbl_assign_amenity_zone'),
                  style: const TextStyle(color: TColors.alterColor),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: controller.searchTextController,
                  onChanged: (query) => controller.searchQuery(query),
                  decoration: InputDecoration(
                    hintText: AppLocalization.of(
                      context,
                    ).translate('edit_object_screen.lbl_search_units'),
                    prefixIcon: const Icon(Iconsax.search_normal),
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
