import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/data/repositories/authentication/authentication_repository.dart';
import 'package:xm_frontend/features/shop/controllers/booking/booking_controller.dart';
import 'package:xm_frontend/features/shop/screens/booking/all_bookings/table/data_table.dart';
import 'package:xm_frontend/features/shop/screens/booking/all_bookings/widgets/table_header.dart';
import 'package:xm_frontend/features/shop/screens/booking/dialogs/view_toggle_widget.dart';
import 'package:xm_frontend/features/shop/screens/booking/widgets/booking_calendar_view.dart';
import 'package:xm_frontend/features/shop/screens/request/all_bookings/table/data_table.dart';
import 'package:xm_frontend/features/shop/screens/request/all_bookings/widgets/table_header.dart';

import 'package:xm_frontend/utils/constants/sizes.dart';

class RequestsTab extends StatelessWidget {
  const RequestsTab({super.key, required this.isPendingShown});

  final bool isPendingShown;

  @override
  Widget build(BuildContext context) {
    final companyId = AuthenticationRepository.instance.currentUser?.companyId;

    // final controller = Get.put(
    //   BookingController(
    //     sourceType: BookingSourceType.agency,
    //     id: int.parse(companyId!),
    //   ),
    //   tag: 'agency_bookings',
    // );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Table Header
          RequestTableHeader(),
          SizedBox(height: TSizes.spaceBtwItems),

          // Table
          // Obx(() {
          //   if (controller.currentView.value == 'calendar') {
          //     return BookingCalendarView(); // Replace with your actual widget
          //   } else {
          //     return RequestsTable(); // Existing table
          //   }
          // }),
          RequestsTable(isPendingShown: isPendingShown),
        ],
      ),
    );
  }
}
