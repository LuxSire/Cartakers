import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/data/models/building_model.dart';
import 'package:xm_frontend/features/shop/controllers/amenity/amenity_controller.dart';
import 'package:xm_frontend/features/shop/controllers/building/building_unit_detail_controller.dart';
import 'package:xm_frontend/features/shop/controllers/building/edit_building_controller.dart';
import 'package:xm_frontend/features/shop/screens/amenity/dialogs/assign_amenity_zone.dart';
import 'package:xm_frontend/utils/constants/colors.dart';

class BuildingUnitsTableHeader extends StatelessWidget {
  const BuildingUnitsTableHeader({super.key, required this.building});

  final BuildingModel building;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BuildingUnitDetailController());

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

                  controllerAssign.buildingId.value = int.parse(building.id!);

                  controllerAssign.loadData();

                  final result = await showDialog<bool>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AssignAmenityZoneDialog(
                        buildingId: int.parse(building.id!),
                      );
                    },
                  );
                  if (result == true) {
                    controller.getUnitContracts(controller.unit.value);
                  }
                },
                icon: const Icon(
                  Iconsax.tick_circle,
                  color: TColors.alterColor,
                ),
                label: Text(
                  AppLocalization.of(
                    context,
                  ).translate('edit_building_screen.lbl_assign_amenity_zone'),
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
                  ).translate('edit_building_screen.lbl_search_units'),
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

                  controllerAssign.buildingId.value = int.parse(building.id!);

                  controllerAssign.loadData();

                  final result = await showDialog<bool>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AssignAmenityZoneDialog(
                        buildingId: int.parse(building.id!),
                      );
                    },
                  );
                  if (result == true) {
                    controller.getUnitContracts(controller.unit.value);
                  }
                },
                icon: const Icon(
                  Iconsax.tick_circle,
                  color: TColors.alterColor,
                ),
                label: Text(
                  AppLocalization.of(
                    context,
                  ).translate('edit_building_screen.lbl_assign_amenity_zone'),
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
                    ).translate('edit_building_screen.lbl_search_units'),
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
