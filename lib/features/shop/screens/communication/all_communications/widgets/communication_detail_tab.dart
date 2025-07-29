import 'package:flutter/material.dart';
import 'package:xm_frontend/features/shop/screens/communication/all_communications/widgets/messages_tab.dart';
import 'package:xm_frontend/features/shop/screens/tenant/widgets/bookings_tab.dart';
import 'package:xm_frontend/features/shop/screens/tenant/widgets/tenant_documents_tab.dart';
import 'package:xm_frontend/features/shop/screens/tenant/widgets/tenant_requests_tab.dart';
import 'package:xm_frontend/features/shop/screens/tenant/widgets/tenant_tab.dart';
import 'package:xm_frontend/features/shop/screens/tenants_contracts/widgets/contracts_tab.dart';
import 'package:xm_frontend/features/shop/screens/tenants_contracts/widgets/tenants_tab.dart';

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
