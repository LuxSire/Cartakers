import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/data/models/object_model.dart';
import 'package:xm_frontend/features/shop/controllers/object/edit_object_controller.dart';
import 'package:xm_frontend/features/shop/screens/object/edit_object/widgets/object_units.dart';
import 'package:xm_frontend/features/shop/screens/object/edit_object/widgets/edit_object_form.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../utils/constants/sizes.dart';

class EditObjectDesktopScreen extends StatelessWidget {
  const EditObjectDesktopScreen({super.key, required this.object});

  final ObjectModel object;

  @override
  Widget build(BuildContext context) {
    // get edit controller
    final controller = Get.put(EditObjectController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              TBreadcrumbsWithHeading(
                onreturnUpdated: () => controller.isDataUpdated.value,
                returnToPreviousScreen: true,
                heading: AppLocalization.of(
                  context,
                ).translate('edit_object_screen.lbl_object_details'),
                breadcrumbItems: [],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Right Side
                  Expanded(
                    child: Column(
                      children: [
                        // Form
                        EditObjectForm(object: object),
                      ],
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwSections),

                  // Left Side units
                  Expanded(flex: 2, child: ObjectUnits(object: object)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
