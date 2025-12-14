import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cartakers/app/localization/app_localization.dart';
import 'package:cartakers/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:cartakers/common/widgets/loaders/loader_animation.dart';
import 'package:cartakers/features/shop/controllers/object/object_controller.dart';
import 'package:cartakers/features/shop/screens/user/all_users/widgets/table_header.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../table/data_table.dart';

class UsersDesktopScreen extends StatelessWidget {
  const UsersDesktopScreen({super.key});

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
              // Breadcrumbs
              TBreadcrumbsWithHeading(
                heading: AppLocalization.of(
                  context,
                ).translate('users_screen.lbl_users'),
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
                      UserTableHeader(),
                      SizedBox(height: TSizes.spaceBtwItems),

                      // Table
                      UsersTable(),
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
