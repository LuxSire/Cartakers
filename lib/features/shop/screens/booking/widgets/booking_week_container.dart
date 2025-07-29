import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/features/shop/screens/booking/widgets/booking_calendar_week_view.dart';

class BookingWeekContainer extends StatefulWidget {
  const BookingWeekContainer({super.key});

  @override
  _BookingWeekContainerState createState() => _BookingWeekContainerState();
}

class _BookingWeekContainerState extends State<BookingWeekContainer> {
  /// “anchor” date for the week (any day in that week)
  final Rx<DateTime> weekRef = Rx<DateTime>(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final monday = weekRef.value.subtract(
        Duration(days: weekRef.value.weekday - DateTime.monday),
      );
      final sunday = monday.add(const Duration(days: 6));

      final weekLabel = _localizedWeekRange(monday, sunday, context);

      return Column(
        children: [
          // ── Navigation Bar ──────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    weekRef.value = weekRef.value.subtract(
                      const Duration(days: 7),
                    );
                  },
                ),
                Expanded(
                  child: Text(
                    weekLabel,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    weekRef.value = weekRef.value.add(const Duration(days: 7));
                  },
                ),
              ],
            ),
          ),

          // ── The actual week-view calendar ────────────────
          Expanded(
            child: BookingWeekView(
              weekReference: weekRef.value,
              hourRowHeight: 60,
              startHour: 6,
              endHour: 22,
            ),
          ),
        ],
      );
    });
  }

  /// Returns a fully localized “from – to” label for the given dates.
  String _localizedWeekRange(DateTime from, DateTime to, BuildContext context) {
    // 1) figure out the locale tag (e.g. "de_CH" or "fr_FR")
    final localeTag = Get.locale?.toLanguageTag() ?? Intl.getCurrentLocale();

    // 2) format both boundaries in yMMMMd() for that locale
    final fmt = DateFormat.yMMMMd(localeTag);
    final start = fmt.format(from);
    final end = fmt.format(to);

    // 3) grab a translated separator (you can define this in your arb/json):
    //
    //    "general.symbol.range_separator": "–"
    //
    final sep = "-";

    return '$start $sep $end';
  }
}
