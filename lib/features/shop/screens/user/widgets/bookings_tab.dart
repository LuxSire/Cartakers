import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/common/widgets/loaders/animation_loader.dart';
import 'package:xm_frontend/data/models/booking_model.dart';
import 'package:xm_frontend/features/shop/controllers/booking/booking_controller.dart';
import 'package:xm_frontend/features/shop/controllers/user/user_controller.dart';
import 'package:xm_frontend/features/shop/screens/user/dialogs/bookings_filter_dialog.dart';
import 'package:xm_frontend/utils/constants/colors.dart';
import 'package:xm_frontend/utils/constants/image_strings.dart';
import 'package:xm_frontend/utils/constants/sizes.dart';
import 'package:xm_frontend/utils/device/device_utility.dart';
import 'package:xm_frontend/utils/helpers/helper_functions.dart'; // For date formatting

class UserBookingsTab extends StatelessWidget {
  const UserBookingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controllerUser = Get.find<UserController>();

    // final controller = Get.put(
    //   BookingController.tenant(
    //     tenantId: int.parse(controllerTenant.tenantModel.value.id.toString()),
    //   ),
    // );

    final controller = Get.find<BookingController>(tag: 'user_bookings');

    // Load data once during initialization
    // controller.loadData();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Total bookings text
              Obx((() {
                return Text(
                  '${controller.totalBookings.value} ${AppLocalization.of(context).translate('bookings_and_requests_screen.lbl_bookings')}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                );
              })),
              Row(
                children: [
                  // Sort button placeholder
                  // IconButton(
                  //   icon: const Icon(Icons.sort),
                  //   onPressed: () {
                  //     // Implement sorting logic here
                  //   },
                  // ),
                  // Filter button
                  TextButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const BookingsFilterDialog(),
                      );
                    },
                    icon: const Icon(Icons.filter_list, size: 20),
                    label: Text(
                      AppLocalization.of(
                        context,
                      ).translate('general_msgs.msg_filters'),
                      style: TextStyle(color: TColors.primary),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          // Bookings list
          Expanded(
            child: Obx(() {
              if (controller.filteredBookings.isEmpty) {
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
              return ListView.builder(
                itemCount: controller.filteredBookings.length,
                itemBuilder: (context, index) {
                  return _buildBookingCard(
                    controller.filteredBookings[index].title.toString(),
                    controller.filteredBookings[index].formattedDateWithText,
                    controller.filteredBookings[index].startTime.toString(),
                    controller.filteredBookings[index].endTime.toString(),
                    controller.filteredBookings[index],
                    context,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(
    String bookingReference,
    String date,
    String startTime,
    String endTime,
    BookingModel booking,
    BuildContext context,
  ) {
    //final dateAndStartEndTime = "$date, $startTime - $endTime";

    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(
        bottom: 16.0,
      ), // Added bottom margin for spacing
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: TColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.event, color: TColors.primary, size: 30),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                bookingReference,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                date, // Custom date format
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              SizedBox(height: 4),
              Text(
                "${startTime.substring(0, 5)} - ${endTime.substring(0, 5)}",
                style: TextStyle(color: Colors.grey),
              ),
              if (TDeviceUtils.isMobileScreen(context)) ...[
                const SizedBox(height: TSizes.spaceBtwItems),
                if (booking.status == 1) // pending
                  Row(
                    children: [
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.green.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          // Open filter options dialog
                        },
                        icon: const Icon(
                          Iconsax.tick_circle,
                          size: 20,
                          color: Colors.green,
                        ),
                        label: Text(
                          "Confirm",
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                      const SizedBox(width: TSizes.spaceBtwItems),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          // Open filter options dialog
                        },
                        icon: const Icon(
                          Iconsax.close_circle,
                          size: 20,
                          color: Colors.red,
                        ),
                        label: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
              ],
            ],
          ),
          Spacer(),
          if (!TDeviceUtils.isMobileScreen(context)) ...[
            if (booking.status == 1) // pending
              Row(
                children: [
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // Open filter options dialog
                    },
                    icon: const Icon(
                      Iconsax.tick_circle,
                      size: 20,
                      color: Colors.green,
                    ),
                    label: Text(
                      "Confirm",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // Open filter options dialog
                    },
                    icon: const Icon(
                      Iconsax.close_circle,
                      size: 20,
                      color: Colors.red,
                    ),
                    label: Text("Cancel", style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
          ],

          if (booking.status != 1) // pending
            Text(
              THelperFunctions.getStatusText(booking.status!),

              style: TextStyle(
                color: THelperFunctions.getStatusColor(booking.status!),

                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}
