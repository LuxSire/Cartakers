import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:xm_frontend/data/models/booking_model.dart';
import 'package:xm_frontend/features/shop/controllers/booking/booking_controller.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:xm_frontend/features/shop/screens/booking/dialogs/view_bookings_dialog.dart';

class BookingCalendarView extends StatefulWidget {
  const BookingCalendarView({super.key});

  @override
  State<BookingCalendarView> createState() => _BookingCalendarViewState();
}

class _BookingCalendarViewState extends State<BookingCalendarView> {
  final controller = Get.find<BookingController>(tag: 'company_bookings');

  DateTime? _lastTapDay;
  DateTime? _lastTapTime;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      controller.calendarRebuildTrigger.value; // triggers rebuild

      return Column(
        children: [
          _buildCustomHeader(context),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 600, maxHeight: 650),
            child: TableCalendar(
              onPageChanged: (focusedDay) {
                controller.focusedDay.value = focusedDay;
              },

              headerVisible: false,
              rowHeight: 95,
              focusedDay: controller.focusedDay.value,
              firstDay: DateTime.utc(2025, 1, 1),
              lastDay: DateTime.utc(2050, 12, 31),
              selectedDayPredicate:
                  (day) => isSameDay(controller.selectedDay.value, day),
              // onDaySelected: (selected, focused) {
              //   controller.selectedDay.value = selected;
              //   controller.focusedDay.value = focused;
              // },
              onDaySelected: (selected, focused) {
                final now = DateTime.now();
                if (_lastTapDay != null &&
                    isSameDay(selected, _lastTapDay!) &&
                    _lastTapTime != null &&
                    now.difference(_lastTapTime!) <
                        const Duration(milliseconds: 500)) {
                  //  debugPrint(" Double tap detected on \$selected");
                  showDialog(
                    context: context,
                    builder: (_) => ViewBookingsDialog(date: selected),
                  );
                  //  controller.onDayDoubleTap(selected);
                }
                _lastTapDay = selected;
                _lastTapTime = now;

                controller.selectedDay.value = selected;
                controller.focusedDay.value = focused;
              },
              // eventLoader: (day) {
              //   return controller.bookingsByDate[DateTime(
              //         day.year,
              //         day.month,
              //         day.day,
              //       )] ??
              //       [];
              // },
              eventLoader: (day) {
                final dateKey = DateTime(day.year, day.month, day.day);
                return controller.bookingsByDate[dateKey] ?? [];
              },

              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                markersMaxCount: 4,
                cellMargin: const EdgeInsets.all(4),
                cellPadding: const EdgeInsets.only(
                  bottom: 60,
                  left: 180,
                ), // gives space for markers
                todayDecoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(6),
                ),
                defaultDecoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(6),
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),

              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (events.isEmpty) return const SizedBox.shrink();

                  final groupedEvents = events.cast<BookingModel>();
                  final maxVisible = 2;
                  final visibleEvents = groupedEvents.take(maxVisible).toList();
                  final remaining = groupedEvents.length - visibleEvents.length;

                  return Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 30,
                        left: 8,
                        right: 30,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ...visibleEvents.map((booking) {
                            Color bgColor;
                            Color textColor;

                            // switch (booking.status) {
                            //   case 1: // pending
                            //     bgColor = Colors.orange.shade100;
                            //     textColor = Colors.orange.shade800;
                            //     break;
                            //   case 7: // confirmed
                            //     bgColor = Colors.blue.shade100;
                            //     textColor = Colors.blue.shade800;
                            //     break;
                            //   case 3: // completed
                            //     bgColor = Colors.green.shade100;
                            //     textColor = Colors.green.shade800;
                            //     break;
                            //   case 5: // cancelled
                            //     bgColor = Colors.red.shade100;
                            //     textColor = Colors.red.shade800;
                            //     break;
                            //   default:
                            //     bgColor = Colors.grey.shade200;
                            //     textColor = Colors.black87;
                            // }

                            switch (booking.status) {
                              case 1: // pending
                                bgColor = Colors.orange.shade100;
                                textColor = Colors.orange.shade800;
                                break;

                              default:
                                bgColor = Colors.blue.shade100;
                                textColor = Colors.blue.shade800;
                            }

                            return Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 1),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                booking.title ?? "Booking",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                            );
                          }),
                          if (remaining > 0)
                            Container(
                              margin: const EdgeInsets.only(top: 2),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                "+$remaining",
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },

                defaultBuilder: (context, day, focusedDay) {
                  return Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6, right: 6),
                      child: Text(
                        '${day.day}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
                todayBuilder: (context, day, focusedDay) {
                  return Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6, right: 6),
                      child: Text(
                        '${day.day}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildCustomHeader(BuildContext context) {
    final focused = controller.focusedDay.value;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Arrow
          IconButton(
            icon: const Icon(Icons.arrow_left),
            onPressed: () {
              controller.focusedDay.value = DateTime(
                focused.year,
                focused.month - 1,
              );
            },
          ),

          // Month-Year Button
          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: focused,
                firstDate: DateTime(2020),
                lastDate: DateTime(2050),
                initialDatePickerMode: DatePickerMode.year,
              );
              if (picked != null) {
                controller.focusedDay.value = DateTime(
                  picked.year,
                  picked.month,
                );
              }
            },
            child: Text(
              DateFormat.yMMMM().format(focused),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),

          // Right Arrow
          IconButton(
            icon: const Icon(Icons.arrow_right),
            onPressed: () {
              controller.focusedDay.value = DateTime(
                focused.year,
                focused.month + 1,
              );
            },
          ),
        ],
      ),
    );
  }
}
