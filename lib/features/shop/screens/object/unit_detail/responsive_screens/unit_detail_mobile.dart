import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:cartakers/data/models/unit_model.dart';
import 'package:cartakers/features/shop/controllers/object/object_unit_controller.dart';
import 'package:cartakers/features/shop/controllers/object/object_unit_detail_controller.dart';
import 'package:cartakers/features/shop/screens/object/unit_detail/widgets/unit_contracts.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../widgets/unit_users.dart';
import '../widgets/unit_info.dart';

class UnitDetailMobileScreen extends StatelessWidget {
  const UnitDetailMobileScreen({super.key, required this.unit});

  final UnitModel unit;

  @override
  Widget build(BuildContext context) {
    final unitDetailController = Get.find<ObjectUnitDetailController>();

    final objectId = unit.objectId;

    final unitController = Get.put(ObjectUnitController());

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
              UnitInfo(),
              const SizedBox(height: TSizes.spaceBtwSections),

              //const UnitUsers(),

              // history
              //UnitContracts(unit: unit),
              const SizedBox(height: TSizes.spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }
}
