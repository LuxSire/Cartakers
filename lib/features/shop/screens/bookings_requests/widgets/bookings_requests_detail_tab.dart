import 'package:flutter/material.dart';
import 'package:xm_frontend/features/shop/screens/bookings_requests/widgets/bookings_tab.dart';
import 'package:xm_frontend/features/shop/screens/bookings_requests/widgets/requests_tab.dart';

class BookingsRequestsDetailsTab extends StatelessWidget {
  final String tabType;
  final bool isFiltered;

  const BookingsRequestsDetailsTab({
    super.key,
    required this.tabType,
    required this.isFiltered,
  });

  @override
  Widget build(BuildContext context) {
    switch (tabType) {
      case 'bookings':
        return BookingsTab();
      case 'requests':
        return RequestsTab(isPendingShown: isFiltered);

      default:
        return Center(child: Text('Unknown Tab'));
    }
  }
}
