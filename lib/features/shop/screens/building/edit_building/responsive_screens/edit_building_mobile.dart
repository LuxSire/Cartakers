import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/data/models/building_model.dart';
import 'package:xm_frontend/features/shop/controllers/building/edit_building_controller.dart';
import 'package:xm_frontend/features/shop/screens/building/edit_building/widgets/building_units.dart';
import 'package:xm_frontend/features/shop/screens/building/edit_building/widgets/edit_building_form.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';

class EditBuildingMobileScreen extends StatelessWidget {
  const EditBuildingMobileScreen({super.key, required this.building});

  final BuildingModel building;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditBuildingController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TBreadcrumbsWithHeading(
                onreturnUpdated: () => controller.isDataUpdated.value,
                returnToPreviousScreen: true,
                heading: AppLocalization.of(
                  context,
                ).translate('edit_building_screen.lbl_building_details'),
                breadcrumbItems: [
                  // Routes.buildingsUnits,
                  // AppLocalization.of(
                  //   context,
                  // ).translate('edit_building_screen.lbl_building_details'),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Form
              EditBuildingForm(building: building),

              const SizedBox(height: TSizes.spaceBtwSections),
              BuildingUnits(building: building),
            ],
          ),
        ),
      ),
    );
  }
}
