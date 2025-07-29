import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:xm_frontend/data/models/unit_model.dart';
import 'package:xm_frontend/features/shop/controllers/building/building_unit_controller.dart';
import 'package:xm_frontend/features/shop/controllers/building/building_unit_detail_controller.dart';
import 'package:xm_frontend/features/shop/screens/building/unit_detail/widgets/unit_contracts.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../widgets/unit_tenants.dart';
import '../widgets/unit_info.dart';

class UnitDetailMobileScreen extends StatelessWidget {
  const UnitDetailMobileScreen({super.key, required this.unit});

  final UnitModel unit;

  @override
  Widget build(BuildContext context) {
    final unitDetailController = Get.find<BuildingUnitDetailController>();

    final buildingId = unit.buildingId;

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
                breadcrumbItems: const [
                  // Routes.buildingsUnits,
                  // 'Building Unit Details',
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Body
              const UnitInfo(),
              const SizedBox(height: TSizes.spaceBtwSections),

              const UnitTenants(),

              // history
              UnitContracts(unit: unit),
              const SizedBox(height: TSizes.spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }
}
