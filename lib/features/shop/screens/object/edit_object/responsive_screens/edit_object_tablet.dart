import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/data/models/object_model.dart';
import 'package:xm_frontend/features/shop/controllers/object/edit_object_controller.dart';
import 'package:xm_frontend/features/shop/screens/object/edit_object/widgets/object_units.dart';
import 'package:xm_frontend/features/shop/screens/object/edit_object/widgets/edit_object_form.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';

class EditObjectTabletScreen extends StatelessWidget {
  const EditObjectTabletScreen({super.key, required this.object});

  final ObjectModel object;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditObjectController());
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
                ).translate('edit_object_screen.lbl_object_details'),
                breadcrumbItems: [
                  // Routes.buildingsUnits,
                  // AppLocalization.of(
                  //   context,
                  // ).translate('edit_building_screen.lbl_building_details'),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Form
              EditObjectForm(object: object),

              const SizedBox(height: TSizes.spaceBtwSections),

              // Left Side units
              ObjectUnits(object: object),
            ],
          ),
        ),
      ),
    );
  }
}
