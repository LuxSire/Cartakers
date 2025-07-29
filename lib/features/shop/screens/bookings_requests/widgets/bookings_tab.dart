import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/data/repositories/authentication/authentication_repository.dart';
import 'package:xm_frontend/features/shop/controllers/booking/booking_controller.dart';
import 'package:xm_frontend/features/shop/screens/booking/all_bookings/table/data_table.dart';
import 'package:xm_frontend/features/shop/screens/booking/all_bookings/widgets/table_header.dart';
import 'package:xm_frontend/features/shop/screens/booking/dialogs/view_toggle_widget.dart';
import 'package:xm_frontend/features/shop/screens/booking/widgets/booking_calendar_view.dart';
import 'package:xm_frontend/features/shop/screens/booking/widgets/booking_calendar_week_view.dart';
import 'package:xm_frontend/features/shop/screens/booking/widgets/booking_week_container.dart';

import 'package:xm_frontend/utils/constants/sizes.dart';

class BookingsTab extends StatelessWidget {
  const BookingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final agencyId = AuthenticationRepository.instance.currentUser?.agencyId;

    final controller = Get.put(
      BookingController(
        sourceType: BookingSourceType.agency,
        id: int.parse(agencyId!),
      ),
      tag: 'agency_bookings',
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Table Header
          BookingTableHeader(),
          SizedBox(height: TSizes.spaceBtwItems),

          // Table
          // Obx(() {
          //   if (controller.currentView.value == 'calendar') {
          //     return BookingCalendarView(); // Replace with your actual widget
          //   } else {
          //     return BookingsTable(); // Existing table
          //   }
          // }),
          Expanded(
            child: Obx(() {
              return controller.currentView.value == ViewMode.calendar
                  ? BookingCalendarView()
                  : BookingWeekContainer();
            }),
          ),
        ],
      ),
    );
  }
}
