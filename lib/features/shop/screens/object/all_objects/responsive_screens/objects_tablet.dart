import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/features/shop/controllers/object/object_controller.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/loaders/loader_animation.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/customer/customer_controller.dart';
import '../table/data_table.dart';
import '../widgets/table_header.dart';

class ObjectsTabletScreen extends StatelessWidget {
  const ObjectsTabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ObjectController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TBreadcrumbsWithHeading(
                heading: AppLocalization.of(
                  context,
                ).translate('objects_screen.lbl_objects'),
                breadcrumbItems: [
                  // AppLocalization.of(
                  //   context,
                  // ).translate('buildings_screen.lbl_buildings'),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections), // Table Body
              // Table Body
              Obx(() {
                // Show Loader
                if (controller.isLoading.value) return const TLoaderAnimation();

                return const TRoundedContainer(
                  child: Column(
                    children: [
                      // Table Header
                      ObjectTableHeader(),
                      SizedBox(height: TSizes.spaceBtwItems),

                      // Table
                      ObjectTable(),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
