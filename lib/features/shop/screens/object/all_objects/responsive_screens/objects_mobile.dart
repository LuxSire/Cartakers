import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cartakers/app/localization/app_localization.dart';
import 'package:cartakers/features/shop/controllers/object/object_controller.dart';
import 'package:cartakers/features/shop/controllers/customer/customer_controller.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/loaders/loader_animation.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../table/data_table.dart';
import '../widgets/table_header.dart';

class ObjectsMobileScreen extends StatelessWidget {
  const ObjectsMobileScreen({super.key});

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
                  // ).translate('objects_screen.lbl_objects'),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              // Table Body
              Obx(() {
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
