import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:cartakers/app/localization/app_localization.dart';
import 'package:cartakers/features/personalization/models/user_model.dart';
import 'package:cartakers/features/shop/controllers/booking/booking_controller.dart';
import 'package:cartakers/features/shop/controllers/request/request_controller.dart';
//import 'package:cartakers/features/shop/controllers/user/user_controller.dart';
import 'package:cartakers/features/personalization/controllers/user_controller.dart';
import 'package:cartakers/features/shop/screens/user/widgets/user_tab_panel.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';

class UserDetailTabletScreen extends StatelessWidget {
  const UserDetailTabletScreen({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserController>();

    debugPrint('User from detail: ${user.toJson()}');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.userModel.value = user;
    });

    final controllerRequest = Get.put(
      RequestController(
        sourceType: RequestSourceType.user,
        id: int.parse(user.id!),
      ),
      tag: 'user_requests',
    );

    final controllerBooking = Get.put(
      BookingController(
        sourceType: BookingSourceType.user,
        id: int.parse(user.id!),
      ),
      tag: 'user_bookings',
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              TBreadcrumbsWithHeading(
                onreturnUpdated: () => true,
                returnToPreviousScreen: true,
                heading: AppLocalization.of(
                  context,
                ).translate('user_screen.lbl_user_details'),
                breadcrumbItems: [
                  // Routes.buildingsUnits,
                  // AppLocalization.of(
                  //   context,
                  // ).translate('tenant_screen.lbl_tenant_details'),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Body
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(children: [const UserTabPanel()]),
                  ),
                  //     const SizedBox(width: TSizes.spaceBtwSections),

                  // Expanded(
                  //   child: Column(
                  //     children: [
                  //       // Tenants Info
                  //       const UnitTenants(),
                  //       const SizedBox(height: TSizes.spaceBtwSections),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
