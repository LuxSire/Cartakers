import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:xm_frontend/common/widgets/images/t_circular_image.dart';
import 'package:xm_frontend/data/models/booking_model.dart';
import 'package:xm_frontend/features/shop/controllers/booking/booking_controller.dart';
import 'package:xm_frontend/features/shop/screens/booking/dialogs/view_bookings_dialog.dart';
import 'package:xm_frontend/utils/constants/colors.dart';
import 'package:xm_frontend/utils/constants/enums.dart';
import 'package:xm_frontend/utils/constants/image_strings.dart';
import 'package:xm_frontend/utils/constants/sizes.dart';

class BookingWeekView extends StatelessWidget {
  /// Any day in the week you want to show
  final DateTime weekReference;

  /// Pixel height per hour row
  final double hourRowHeight;

  /// First hour to display (inclusive)
  final int startHour;

  /// Last hour to display (exclusive)
  final int endHour;

  const BookingWeekView({
    Key? key,
    required this.weekReference,
    this.hourRowHeight = 60,
    this.startHour = 7,
    this.endHour = 22,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<BookingController>(tag: 'agency_bookings');

    // calculate Monday + the next 6 days
    // final monday = weekReference.subtract(
    //   Duration(days: weekReference.weekday - 1),
    // );
    // final days = List.generate(7, (i) => monday.add(Duration(days: i)));

    // pick up the locale
    final localeTag = Get.locale?.toLanguageTag() ?? Intl.getCurrentLocale();

    // calculate Monday + the next 6 days
    final monday = weekReference.subtract(
      Duration(days: weekReference.weekday - DateTime.monday),
    );
    final days = List.generate(7, (i) => monday.add(Duration(days: i)));

    return Obx(() {
      ctrl.calendarRebuildTrigger.value; // triggers rebuild

      return LayoutBuilder(
        builder: (context, constraints) {
          const gutterWidth = 60.0;
          // subtract a pixel so borders don't overflow
          final dayColumnWidth = (constraints.maxWidth - gutterWidth) / 7;

          // total height of all rows + header:
          final totalHeight =
              (endHour - startHour) * hourRowHeight + /* header */ 40;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── HEADER ROW ─────────────────────────────────────
              SizedBox(
                height: 40,
                child: Row(
                  children: [
                    SizedBox(width: gutterWidth),
                    ...days.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final d = entry.value;
                      return Container(
                        width: dayColumnWidth,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border(
                            left:
                                idx > 0
                                    ? BorderSide(color: Colors.grey.shade300)
                                    : BorderSide.none,
                            right:
                                idx < days.length - 1
                                    ? BorderSide(color: Colors.grey.shade300)
                                    : BorderSide.none,
                          ),
                        ),
                        child: Text(
                          //  DateFormat.E().add_d().format(d),
                          DateFormat('EEE d', localeTag).format(d),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),

              // ─── BODY: gutter + day columns ─────────────────────
              Expanded(
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: totalHeight,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ─ Fixed hour gutter ────────────────────────────
                        Column(
                          children: [
                            const SizedBox(height: 30), // under header
                            ...List.generate(endHour - startHour, (i) {
                              final hour = startHour + i;
                              return Container(
                                height: hourRowHeight,
                                width: gutterWidth,
                                alignment: Alignment.topCenter,
                                child: Text(
                                  '${hour.toString().padLeft(2, '0')}:00',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),

                        // ─ Day columns ───────────────────────────────────
                        ...days.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final day = entry.value;

                          final events =
                              ctrl.bookingsByDate[DateTime(
                                day.year,
                                day.month,
                                day.day,
                              )] ??
                              [];

                          return Container(
                            width: dayColumnWidth,
                            decoration: BoxDecoration(
                              border: Border(
                                left:
                                    idx > 0
                                        ? BorderSide(
                                          color: Colors.grey.shade300,
                                        )
                                        : BorderSide.none,
                                right:
                                    idx < days.length - 1
                                        ? BorderSide(
                                          color: Colors.grey.shade300,
                                        )
                                        : BorderSide.none,
                              ),
                            ),
                            child: Stack(
                              children: [
                                // hour lines
                                Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    ...List.generate(endHour - startHour, (_) {
                                      return SizedBox(
                                        height: hourRowHeight,
                                        child: Divider(
                                          height: 1,
                                          color: Colors.grey.shade300,
                                        ),
                                      );
                                    }),
                                  ],
                                ),

                                // bookings
                                ...events.cast<BookingModel>().map((b) {
                                  final partsStart = b.startTime!.split(':');
                                  final partsEnd = b.endTime!.split(':');
                                  final startH =
                                      int.parse(partsStart[0]) +
                                      int.parse(partsStart[1]) / 60.0;
                                  final endH =
                                      int.parse(partsEnd[0]) +
                                      int.parse(partsEnd[1]) / 60.0;
                                  final clampedStart = startH.clamp(
                                    startHour.toDouble(),
                                    endHour.toDouble(),
                                  );
                                  final clampedEnd = endH.clamp(
                                    startHour.toDouble(),
                                    endHour.toDouble(),
                                  );
                                  final top =
                                      (clampedStart - startHour) *
                                          hourRowHeight +
                                      40;
                                  final height =
                                      (clampedEnd - clampedStart) *
                                      hourRowHeight;

                                  if (height <= 0)
                                    return const SizedBox.shrink();

                                  final bgColor =
                                      (b.status == 1)
                                          ? Colors.orange.shade100
                                          : Colors.blue.shade100;
                                  final textColor =
                                      (b.status == 1)
                                          ? Colors.orange.shade800
                                          : Colors.blue.shade800;

                                  return Positioned(
                                    top: top,
                                    left: 4,
                                    right: 4,
                                    height: height,
                                    child: GestureDetector(
                                      onTap:
                                          () => showDialog(
                                            context: context,
                                            builder:
                                                (_) => ViewBookingsDialog(
                                                  date: b.date!,
                                                ),
                                          ),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: bgColor,
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                TCircularImage(
                                                  width: 25,
                                                  height: 25,
                                                  padding: 2,
                                                  fit: BoxFit.cover,
                                                  backgroundColor:
                                                      TColors.primaryBackground,
                                                  image:
                                                      b
                                                              .createdByUserProfileImageUrl
                                                              .isNotEmpty
                                                          ? b.createdByUserProfileImageUrl!
                                                          : TImages.user,
                                                  imageType:
                                                      b
                                                              .createdByUserProfileImageUrl!
                                                              .isNotEmpty
                                                          ? ImageType.network
                                                          : ImageType.asset,
                                                ),
                                                const SizedBox(width: 4),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        b.createdByName ?? '',
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: textColor,
                                                        ),
                                                      ),
                                                      Text(
                                                        b.title ?? '',
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: textColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 2),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    });
  }
}
