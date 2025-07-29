import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/features/personalization/models/user_model.dart';
import 'package:xm_frontend/features/shop/controllers/booking/booking_controller.dart';
import 'package:xm_frontend/features/shop/controllers/request/request_controller.dart';
import 'package:xm_frontend/features/shop/controllers/tenant/tenant_controller.dart';
import 'package:xm_frontend/features/shop/screens/tenant/widgets/tenant_tab_panel.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';

class TenantDetailMobileScreen extends StatelessWidget {
  const TenantDetailMobileScreen({super.key, required this.tenant});

  final UserModel tenant;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TenantController());

    debugPrint('Tenant from detail: ${tenant.toJson()}');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.tenantModel.value = tenant;
    });

    final controllerRequest = Get.put(
      RequestController(
        sourceType: RequestSourceType.tenant,
        id: int.parse(tenant.id!),
      ),
      tag: 'tenant_requests',
    );

    final controllerBooking = Get.put(
      BookingController(
        sourceType: BookingSourceType.tenant,
        id: int.parse(tenant.id!),
      ),
      tag: 'tenant_bookings',
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
                onreturnUpdated: () => controller.isDataUpdated.value,
                returnToPreviousScreen: true,
                heading: AppLocalization.of(
                  context,
                ).translate('tenant_screen.lbl_tenant_details'),
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
                    child: Column(children: [const TenantTabPanel()]),
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
