import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:xm_frontend/features/shop/screens/contract/widgets/bookings_tab.dart';
import 'package:xm_frontend/features/shop/screens/contract/widgets/documents_tab.dart';
import 'package:xm_frontend/features/shop/screens/contract/widgets/requests_tab.dart';
import 'package:xm_frontend/features/shop/screens/contract/widgets/users_tab.dart';
import 'package:xm_frontend/utils/constants/colors.dart';

class ContractDetailsTab extends StatelessWidget {
  final String tabType;

  const ContractDetailsTab({Key? key, required this.tabType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (tabType) {
      case 'tenants':
        return TenantsTab();
      case 'documents':
        return DocumentsTab();
      case 'bookings':
        return BookingsTab();
      case 'requests':
        return RequestsTab();
      // case 'Notes/Logs':
      //   return NotesLogsTab();
      default:
        return Center(child: Text('Unknown Tab'));
    }
  }
}

// Tenants Tab

// Documents Tab

// Booking History Tab
class BookingHistoryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text('Booking #12345'),
          subtitle: Text('Date: 01/01/2025'),
        ),
        // Add more booking history items here...
      ],
    );
  }
}

// Request History Tab
class RequestHistoryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text('Request #98765'),
          subtitle: Text('Status: Completed'),
        ),
        // Add more requests here...
      ],
    );
  }
}

// Notes/Logs Tab
class NotesLogsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text('Maintenance request'),
          subtitle: Text('Status: Completed'),
        ),
        // Add more notes/logs here...
      ],
    );
  }
}
