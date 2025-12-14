import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cartakers/app/localization/app_localization.dart';
import 'package:cartakers/common/widgets/images/t_rounded_image.dart';
import 'package:cartakers/common/widgets/loaders/animation_loader.dart';
import 'package:cartakers/data/repositories/authentication/authentication_repository.dart';
import 'package:cartakers/features/personalization/controllers/settings_controller.dart';
import 'package:cartakers/features/shop/controllers/booking/booking_controller.dart';
import 'package:cartakers/features/shop/controllers/dashboard/dashboard_controller.dart';
import 'package:cartakers/routes/routes.dart';
import 'package:cartakers/utils/constants/colors.dart';
import 'package:cartakers/utils/constants/image_strings.dart';
import 'package:cartakers/utils/constants/sizes.dart';
import 'package:cartakers/utils/device/device_utility.dart';

import '../../../../../common/widgets/containers/circular_container.dart';
import '../../../../../common/widgets/loaders/loader_animation.dart';
import '../../../../../utils/constants/enums.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class BookingCard extends StatelessWidget {
  const BookingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = DashboardController.instance;

    // final buildingId =
    //     SettingsController.instance.settings.value.selectedBuildingId;

    // final controllerBooking = Get.put(
    //   BookingController.building(buildingId: buildingId),
    // );

    final companyId = AuthenticationRepository.instance.currentUser!.companyId;

    final controllerBooking = Get.put(
      BookingController(
        sourceType: BookingSourceType.company,
        id: companyId!,
      ),
      tag: 'company_bookings',
    );

    //controllerBooking.loadData();

    final bookingList = controllerBooking.allRecentBookings;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          final bookings = bookingList;

          if (bookings.isEmpty) {
            return SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
                  child: TAnimationLoaderWidget(
                    height: 250,
                    text: AppLocalization.of(
                      context,
                    ).translate('general_msgs.msg_no_data_found'),
                    animation: TImages.noDataIllustration,
                  ),
                ),
              ),
            );
          }

          return SizedBox(
            height: 400,
            child: ListView.separated(
              itemCount: bookings.length,
              separatorBuilder: (_, __) => Divider(),
              itemBuilder: (context, index) {
                final booking = bookings[index];

                return ListTile(
                  leading: TRoundedImage(
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    padding: 2,
                    imageType:
                        booking.createdByUserProfileImageUrl!.isNotEmpty
                            ? ImageType.network
                            : ImageType.asset,
                    image:
                        booking.createdByUserProfileImageUrl!.isNotEmpty
                            ? booking.createdByUserProfileImageUrl!
                            : TImages.user,
                  ),
                  title: Text(
                    booking.createdByName!,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TColors.txt333333,
                    ),
                  ),
                  subtitle: Text(
                    '${booking.formattedDateWithText}, ${booking.startTime!.substring(0, 5)} - ${booking.endTime!.substring(0, 5)} ',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall!.copyWith(color: TColors.txt666666),
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        booking.title!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        THelperFunctions.getStatusText(
                          booking.status!,
                        ).toUpperCase(),
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: THelperFunctions.getStatusColor(
                            booking.status!,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }),
      ],
    );
  }
}
