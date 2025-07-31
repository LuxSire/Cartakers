import 'package:flutter/material.dart';
import 'package:xm_frontend/features/shop/screens/user/widgets/bookings_tab.dart';
import 'package:xm_frontend/features/shop/screens/user/widgets/user_documents_tab.dart';
import 'package:xm_frontend/features/shop/screens/user/widgets/user_requests_tab.dart';
import 'package:xm_frontend/features/shop/screens/user/widgets/user_tab.dart';

class UserDetailsTab extends StatelessWidget {
  final String tabType;

  const UserDetailsTab({Key? key, required this.tabType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (tabType) {
      case 'user':
        return UserTab();
      case 'documents':
        return UserDocumentsTab();
      case 'bookings':
        return UserBookingsTab();
      case 'requests':
        return UserRequestsTab();

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
