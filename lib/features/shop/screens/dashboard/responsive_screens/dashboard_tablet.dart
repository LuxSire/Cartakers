import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xm_frontend/app/app_controller.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/common/widgets/texts/page_heading.dart';
import 'package:xm_frontend/features/shop/controllers/object/object_controller.dart';
import 'package:xm_frontend/features/shop/screens/object/all_objects/dialogs/create_object.dart';
import 'package:xm_frontend/features/shop/screens/dashboard/widgets/a_dashboard_card.dart';
import 'package:xm_frontend/features/shop/screens/dashboard/widgets/booking_card.dart';
import 'package:xm_frontend/features/shop/screens/dashboard/widgets/object_card.dart';
import 'package:xm_frontend/features/shop/screens/dashboard/widgets/requests_card.dart';
import 'package:xm_frontend/features/shop/screens/dashboard/widgets/vacant_card.dart';
import 'package:xm_frontend/routes/routes.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../common/widgets/icons/t_circular_icon.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/dashboard/dashboard_controller.dart';
import '../table/data_table.dart';
import '../widgets/dashboard_card.dart';

class DashboardTabletScreen extends StatelessWidget {
  const DashboardTabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());

    // Trigger total calculations once when the screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller
          .initDashboardTotals(); //  this replaces calling each one individually
    });

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TPageHeading(
                heading: AppLocalization.of(
                  context,
                ).translate('dashboard_screen.lbl_dashboard'),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => ADashboardCard(
                        onTap: () => Get.toNamed(Routes.objectsUnits),

                        headingIcon: Iconsax.building,
                        headingIconColor: TColors.alterColor,
                        headingIconBgColor: TColors.alterColor.withOpacity(0.1),
                        stats: controller.totalCompanyObjects.value,
                        context: context,
                        title: AppLocalization.of(
                          context,
                        ).translate('dashboard_screen.lbl_objects'),
                        subTitle:
                            controller.totalCompanyObjects.value.toString(),
                      ),
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Expanded(
                    child: Obx(
                      () => ADashboardCard(
                        onTap: () => Get.toNamed(Routes.usersContracts),

                        headingIcon: Iconsax.profile_2user,
                        headingIconColor: Colors.green,
                        headingIconBgColor: Colors.green.withOpacity(0.1),
                        stats: controller.totalObjectUsers.value,
                        context: context,
                        title: AppLocalization.of(
                          context,
                        ).translate('sidebar.lbl_users_and_contracts'),
                        subTitle:
                            ' ${controller.totalObjectUsers.value.toString()}/${controller.totalObjectsContracts.value.toString()}',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => ADashboardCard(
                        onTap: () {
                          // set value in setings controller

                          Get.find<AppController>()
                              .togglePendingRequestsNavigation();

                          Get.toNamed(Routes.bookingsRequests);
                        },
                        headingIcon: Iconsax.document,
                        headingIconColor: Colors.amber,
                        headingIconBgColor: Colors.amber.withOpacity(0.1),
                        stats: controller.totalObjectsPendingRequests.value,
                        context: context,
                        title: AppLocalization.of(
                          context,
                        ).translate('dashboard_screen.lbl_pending_requests'),
                        subTitle:
                            controller.totalObjectsPendingRequests.value
                                .toString(),
                      ),
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Expanded(
                    child: Obx(
                      () => ADashboardCard(
                        onTap: () {
                          Get.toNamed(Routes.communication);
                        },
                        headingIcon: Iconsax.direct,
                        headingIconColor: Colors.deepOrange,
                        headingIconBgColor: Colors.deepOrange.withOpacity(0.1),
                        context: context,
                        title: AppLocalization.of(
                          context,
                        ).translate('sidebar.lbl_communication'),
                        subTitle:
                            controller.totalObjectsMessages.value.toString(),
                        stats: controller.totalObjectsMessages.value,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Weekly Graphs
              //   const TWeeklySalesGraph(),
              // const SizedBox(height: TSizes.spaceBtwSections),

              //  bookings
              // TRoundedContainer(
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Row(
              //         children: [
              //           TCircularIcon(
              //             icon: Iconsax.box,
              //             backgroundColor: Colors.deepPurple.withOpacity(0.1),
              //             color: Colors.deepPurple,
              //             size: TSizes.md,
              //           ),
              //           const SizedBox(width: TSizes.spaceBtwItems),
              //           Text(
              //             AppLocalization.of(
              //               context,
              //             ).translate('dashboard_screen.lbl_recent_bookings'),
              //             style: Theme.of(context).textTheme.headlineSmall,
              //           ),
              //         ],
              //       ),
              //       const SizedBox(height: TSizes.spaceBtwSections),
              //       const BookingCard(),
              //     ],
              //   ),
              // ),
              TRoundedContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            TCircularIcon(
                              icon: Iconsax.building,
                              backgroundColor: TColors.alterColor.withOpacity(
                                0.1,
                              ),
                              color: TColors.alterColor,
                              size: TSizes.md,
                            ),
                            const SizedBox(width: TSizes.spaceBtwItems),
                            Text(
                              AppLocalization.of(
                                context,
                              ).translate('dashboard_screen.lbl_buildings'),
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ],
                        ),
                        TextButton.icon(
                          onPressed: () async {
                            final result = await showDialog<bool>(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => const CreateObjectDialog(),
                            );
                            if (result == true) {
                              final objectController =
                                  Get.find<ObjectController>();

                              objectController.refreshData();
                              controller
                                  .initDashboardTotals(); // Refresh totals after creating a new object
                            }
                          },
                          icon: const Icon(
                            Iconsax.add_circle,
                            color: TColors.alterColor,
                          ),
                          label: Text(
                            AppLocalization.of(context).translate(
                              'buildings_screen.lbl_create_new_building',
                            ),
                            style: const TextStyle(color: TColors.alterColor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),
                    const ObjectCard(),
                  ],
                ),
              ),

              const SizedBox(height: TSizes.spaceBtwSections),

              TRoundedContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        TCircularIcon(
                          icon: Iconsax.building,
                          backgroundColor: TColors.alterColor.withOpacity(0.1),
                          color: TColors.alterColor,
                          size: TSizes.md,
                        ),
                        const SizedBox(width: TSizes.spaceBtwItems),
                        Obx(
                          () => Text(
                            "${AppLocalization.of(context).translate('dashboard_screen.lbl_vacant_units')} (${controller.totalObjectsVacantUnits})",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),
                    const VacantCard(),
                  ],
                ),
              ),

              const SizedBox(height: TSizes.spaceBtwSections),
              TRoundedContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Row(
                          children: [
                            TCircularIcon(
                              icon: Iconsax.document,
                              backgroundColor: Colors.amber.withOpacity(0.1),
                              color: Colors.amber,
                              size: TSizes.md,
                            ),
                            const SizedBox(width: TSizes.spaceBtwItems),
                            Text(
                              '${AppLocalization.of(context).translate('dashboard_screen.lbl_pending_requests')} (${controller.totalObjectsPendingRequests.value})',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ],
                        ),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: () {
                            // set value in setings controller
                            Get.find<AppController>()
                                .togglePendingRequestsNavigation();

                            Get.toNamed(Routes.bookingsRequests);
                          },
                          icon: const Icon(
                            Iconsax.eye,
                            color: TColors.alterColor,
                          ),
                          label: Text(
                            AppLocalization.of(
                              context,
                            ).translate('general_msgs.msg_view_all'),
                            style: const TextStyle(color: TColors.alterColor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),
                    const RequestsCard(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
