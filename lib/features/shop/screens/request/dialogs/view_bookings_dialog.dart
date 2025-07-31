import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/common/widgets/images/t_circular_image.dart';
import 'package:xm_frontend/common/widgets/loaders/animation_loader.dart';
import 'package:xm_frontend/common/widgets/loaders/loader_animation.dart';
import 'package:xm_frontend/data/models/booking_model.dart';
import 'package:xm_frontend/features/shop/controllers/booking/booking_controller.dart';
import 'package:xm_frontend/utils/constants/colors.dart';
import 'package:xm_frontend/utils/constants/enums.dart';
import 'package:xm_frontend/utils/constants/image_strings.dart';
import 'package:xm_frontend/utils/constants/sizes.dart';
import 'package:xm_frontend/utils/helpers/helper_functions.dart';

class ViewBookingsDialog extends StatelessWidget {
  final DateTime date;

  const ViewBookingsDialog({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingController>(tag: 'agency_bookings');

    final theme = Theme.of(context);

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: 700,
          height: 600,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() {
                final dayBookings = controller.filteredBookings.where(
                  (b) =>
                      b.date != null &&
                      b.date!.year == date.year &&
                      b.date!.month == date.month &&
                      b.date!.day == date.day,
                );

                final confirmed =
                    dayBookings.where((b) => b.status != 1).toList();
                final pending =
                    dayBookings.where((b) => b.status == 1).toList();

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.blue.shade50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${date.day}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(DateFormat.EEEE().format(date)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (confirmed.isNotEmpty)
                            _tag(
                              '${confirmed.length} ${AppLocalization.of(context).translate('bookings_screen.lbl_bookings')}',
                              TColors.primary,
                            ),
                          if (pending.isNotEmpty) const SizedBox(width: 8),
                          if (pending.isNotEmpty)
                            _tag(
                              '${pending.length} ${AppLocalization.of(context).translate('bookings_screen.lbl_booking_requests')}',
                              Colors.amber,
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        TabBar(
                          tabAlignment: TabAlignment.start,
                          isScrollable: true,
                          indicatorColor: TColors.alterColor,
                          labelColor: TColors.alterColor,
                          indicatorWeight: 1,
                          unselectedLabelColor: Colors.black.withOpacity(0.6),
                          tabs: [
                            Tab(
                              text: AppLocalization.of(
                                context,
                              ).translate('bookings_screen.lbl_bookings'),
                            ),
                            Tab(
                              text: AppLocalization.of(context).translate(
                                'bookings_screen.lbl_booking_requests',
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Obx(() {
                            final dayBookings = controller.filteredBookings
                                .where(
                                  (b) =>
                                      b.date != null &&
                                      b.date!.year == date.year &&
                                      b.date!.month == date.month &&
                                      b.date!.day == date.day,
                                );

                            final confirmed =
                                dayBookings
                                    .where((b) => b.status != 1)
                                    .toList();
                            final pending =
                                dayBookings
                                    .where((b) => b.status == 1)
                                    .toList();

                            return TabBarView(
                              children: [
                                _bookingList(
                                  confirmed,
                                  controller,
                                  showActions: false,
                                ),
                                _bookingList(
                                  pending,
                                  controller,
                                  showActions: true,
                                ),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  Widget _bookingList(
    List<BookingModel> bookings,
    BookingController controller, {
    bool showActions = false,
  }) {
    if (bookings.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
          child: TAnimationLoaderWidget(
            height: 250,
            text: AppLocalization.of(
              Get.context!,
            ).translate('general_msgs.msg_no_data_found'),
            animation: TImages.noDataIllustration,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0.5,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color.fromARGB(255, 225, 225, 225),
                width: 1,
              ),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue.shade50,
                        child: Text(
                          booking.title?.substring(0, 1).toUpperCase() ?? 'B',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking.title ?? 'Booking',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              booking.objectName ?? '',
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                booking.status == 1
                                    ? Text(
                                      AppLocalization.of(context).translate(
                                        'bookings_screen.lbl_requested_by',
                                      ),
                                      style: const TextStyle(fontSize: 12),
                                    )
                                    : Text(
                                      AppLocalization.of(context).translate(
                                        'bookings_screen.lbl_booked_by',
                                      ),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                const SizedBox(width: 4),
                                TCircularImage(
                                  width: 25,
                                  height: 25,
                                  padding: 2,
                                  fit: BoxFit.cover,
                                  backgroundColor: TColors.primaryBackground,
                                  image:
                                      booking
                                              .createdByUserProfileImageUrl!
                                              .isNotEmpty
                                          ? booking.createdByUserProfileImageUrl
                                          : TImages.user,
                                  imageType:
                                      booking
                                              .createdByUserProfileImageUrl!
                                              .isNotEmpty
                                          ? ImageType.network
                                          : ImageType.asset,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  booking.createdByName!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${booking.startTime.toString().substring(0, 5)} - ${booking.endTime.toString().substring(0, 5)}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            THelperFunctions.getStatusText(booking.status!),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: THelperFunctions.getStatusColor(
                                booking.status!,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (showActions) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton.icon(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.green.withOpacity(0.1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Get.defaultDialog(
                                title: AppLocalization.of(
                                  Get.context!,
                                ).translate('general_msgs.msg_confirm_booking'),
                                content: Text(
                                  '${AppLocalization.of(Get.context!).translate('general_msgs.msg_question_confirm_booking')} "${booking.title ?? ''}"',
                                ),
                                confirm: SizedBox(
                                  width: 60,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      Get.back();
                                      final result = await controller
                                          .updateBookingStatus(booking, 7);
                                      if (result) {
                                        booking.status = 7;
                                        controller.filteredBookings.refresh();
                                        controller.groupBookingsByDate();
                                      }
                                    },
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: TSizes.buttonHeight / 2,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          TSizes.buttonRadius * 5,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      AppLocalization.of(
                                        Get.context!,
                                      ).translate('general_msgs.msg_yes'),
                                    ),
                                  ),
                                ),
                                cancel: SizedBox(
                                  width: 80,
                                  child: OutlinedButton(
                                    onPressed: () => Get.back(),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: TSizes.buttonHeight / 2,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          TSizes.buttonRadius * 5,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      AppLocalization.of(
                                        Get.context!,
                                      ).translate('general_msgs.msg_cancel'),
                                    ),
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Iconsax.tick_circle,
                              size: 20,
                              color: Colors.green,
                            ),
                            label: Text(
                              AppLocalization.of(
                                context,
                              ).translate('general_msgs.msg_confirm'),
                              style: const TextStyle(color: Colors.green),
                            ),
                          ),
                        ),
                        const SizedBox(width: TSizes.spaceBtwItems),
                        Expanded(
                          child: TextButton.icon(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.red.withOpacity(0.1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () async {
                              Get.defaultDialog(
                                title: AppLocalization.of(
                                  Get.context!,
                                ).translate('general_msgs.msg_reject_booking'),
                                content: Text(
                                  '${AppLocalization.of(Get.context!).translate('general_msgs.msg_question_reject_booking')} "${booking.title ?? ''}"',
                                ),
                                confirm: SizedBox(
                                  width: 60,
                                  child: ElevatedButton(
                                    //  onPressed: () async => await deleteOnConfirm(item),
                                    onPressed: () async {
                                      Get.back();
                                      final result = await controller
                                          .updateBookingStatus(booking, 5);
                                      if (result) {
                                        booking.status = 5;
                                        controller.filteredBookings.refresh();
                                        controller.groupBookingsByDate();
                                      }
                                    },
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: TSizes.buttonHeight / 2,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          TSizes.buttonRadius * 5,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      AppLocalization.of(
                                        Get.context!,
                                      ).translate('general_msgs.msg_yes'),
                                    ),
                                  ),
                                ),
                                cancel: SizedBox(
                                  width: 80,
                                  child: OutlinedButton(
                                    onPressed: () => Get.back(),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: TSizes.buttonHeight / 2,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          TSizes.buttonRadius * 5,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      AppLocalization.of(
                                        Get.context!,
                                      ).translate('general_msgs.msg_cancel'),
                                    ),
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Iconsax.close_circle,
                              size: 20,
                              color: Colors.red,
                            ),
                            label: Text(
                              AppLocalization.of(
                                context,
                              ).translate('general_msgs.msg_reject'),
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
