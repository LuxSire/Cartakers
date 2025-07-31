import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/data/models/unit_model.dart';
import 'package:xm_frontend/features/shop/controllers/object/object_unit_controller.dart';
import 'package:xm_frontend/features/shop/controllers/object/object_unit_detail_controller.dart';
import 'package:xm_frontend/features/shop/screens/object/unit_detail/widgets/unit_contracts.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../widgets/unit_users.dart';
import '../widgets/unit_info.dart';

class UnitDetailTabletScreen extends StatelessWidget {
  const UnitDetailTabletScreen({super.key, required this.unit});

  final UnitModel unit;

  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(UnitDetailController());
    // controller.order.value = order;

    final unitDetailController = Get.find<ObjectUnitDetailController>();

    final objectId = unit.objectId;

    final unitController = Get.put(ObjectUnitController());

    // Set the unit into controller (only once when screen builds)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unitController.unit.value = unit;
    });

    double screenWidth = MediaQuery.of(context).size.width;

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isDesktop = screenWidth > 900;
        bool isTablet = screenWidth > 600 && screenWidth <= 900;
        bool showImage = screenWidth > 850; // Hide image for small tablets
        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Breadcrumbs
                  TBreadcrumbsWithHeading(
                    onreturnUpdated:
                        () => unitDetailController.isDataUpdated.value,

                    returnToPreviousScreen: true,
                    heading: unit.unitNumber!,
                    breadcrumbItems: const [
                      // Routes.buildingsUnits,
                      // 'Building Unit Details',
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  // Body
                  isDesktop
                      ? Row(
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

                                // Contract history
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
                                const UnitUsers(),
                                const SizedBox(height: TSizes.spaceBtwSections),
                              ],
                            ),
                          ),
                        ],
                      )
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Unit Info
                          const UnitInfo(),
                          const SizedBox(height: TSizes.spaceBtwSections),

                          // Users Info
                          const UnitUsers(),

                          // Contract history
                          UnitContracts(unit: unit),
                          const SizedBox(height: TSizes.spaceBtwSections),
                        ],
                      ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
