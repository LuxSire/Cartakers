import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/data/models/unit_model.dart';
import 'package:xm_frontend/features/shop/controllers/building/building_unit_controller.dart';
import 'package:xm_frontend/features/shop/controllers/building/building_unit_detail_controller.dart';
import 'package:xm_frontend/features/shop/screens/building/unit_detail/widgets/unit_contracts.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../widgets/unit_tenants.dart';
import '../widgets/unit_info.dart';

class UnitDetailDesktopScreen extends StatelessWidget {
  const UnitDetailDesktopScreen({super.key, required this.unit});

  final UnitModel unit;

  @override
  Widget build(BuildContext context) {
    final unitDetailController = Get.find<BuildingUnitDetailController>();

    final buildingId = unit.buildingId;

    // final unitController = Get.put(
    //   BuildingUnitController(buildingId: int.parse(buildingId.toString())),
    // );

    final unitController = Get.put(BuildingUnitController());

    // Set the unit into controller (only once when screen builds)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unitController.unit.value = unit;
    });

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              TBreadcrumbsWithHeading(
                onreturnUpdated: () => unitDetailController.isDataUpdated.value,
                returnToPreviousScreen: true,
                heading: unit.unitNumber!,
                breadcrumbItems: const [],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Body
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Side Order Information
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        // Unit Info
                        const UnitInfo(),
                        const SizedBox(height: TSizes.spaceBtwSections),

                        // history
                        UnitContracts(unit: unit),
                        const SizedBox(height: TSizes.spaceBtwSections),
                      ],
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwSections),

                  // Right Side Order Orders
                  Expanded(
                    child: Column(
                      children: [
                        // Tenants Info
                        const UnitTenants(),
                        const SizedBox(height: TSizes.spaceBtwSections),
                      ],
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
