import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:xm_frontend/common/widgets/loaders/loader_animation.dart';
import 'package:xm_frontend/features/shop/controllers/building/building_controller.dart';
import 'package:xm_frontend/features/shop/screens/tenant/all_tenants/widgets/table_header.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../table/data_table.dart';

class TenantsDesktopScreen extends StatelessWidget {
  const TenantsDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BuildingController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              TBreadcrumbsWithHeading(
                heading: AppLocalization.of(
                  context,
                ).translate('tenants_screen.lbl_tenants'),
                breadcrumbItems: [
                  // AppLocalization.of(
                  //   context,
                  // ).translate('tenants_screen.lbl_tenants'),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Table Body
              Obx(() {
                // Show Loader
                if (controller.isLoading.value) return const TLoaderAnimation();

                return const TRoundedContainer(
                  child: Column(
                    children: [
                      // Table Header
                      TenantTableHeader(),
                      SizedBox(height: TSizes.spaceBtwItems),

                      // Table
                      TenantsTable(),
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
