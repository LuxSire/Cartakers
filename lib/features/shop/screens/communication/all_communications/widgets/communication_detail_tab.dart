import 'package:flutter/material.dart';
import 'package:xm_frontend/features/shop/screens/communication/all_communications/widgets/messages_tab.dart';
import 'package:xm_frontend/features/shop/screens/user/widgets/bookings_tab.dart';
import 'package:xm_frontend/features/shop/screens/user/widgets/user_documents_tab.dart';
import 'package:xm_frontend/features/shop/screens/user/widgets/user_requests_tab.dart';
import 'package:xm_frontend/features/shop/screens/user/widgets/user_tab.dart';
import 'package:xm_frontend/features/shop/screens/users_contracts/widgets/contracts_tab.dart';
import 'package:xm_frontend/features/shop/screens/users_contracts/widgets/users_tab.dart';

class CommunicationDetailsTab extends StatelessWidget {
  final String tabType;

  const CommunicationDetailsTab({super.key, required this.tabType});

  @override
  Widget build(BuildContext context) {
    switch (tabType) {
      case 'messages':
        return MessagesTab();
      case 'contracts':
        return ContractsTab();

      default:
        return Center(child: Text('Unknown Tab'));
    }
  }
}
