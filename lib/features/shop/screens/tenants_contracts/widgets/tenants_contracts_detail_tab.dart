import 'package:flutter/material.dart';
import 'package:xm_frontend/features/shop/screens/tenant/widgets/bookings_tab.dart';
import 'package:xm_frontend/features/shop/screens/tenant/widgets/tenant_documents_tab.dart';
import 'package:xm_frontend/features/shop/screens/tenant/widgets/tenant_requests_tab.dart';
import 'package:xm_frontend/features/shop/screens/tenant/widgets/tenant_tab.dart';
import 'package:xm_frontend/features/shop/screens/tenants_contracts/widgets/app_invitation_tab.dart';
import 'package:xm_frontend/features/shop/screens/tenants_contracts/widgets/contracts_tab.dart';
import 'package:xm_frontend/features/shop/screens/tenants_contracts/widgets/tenants_tab.dart';

class TenantsContractsDetailsTab extends StatelessWidget {
  final String tabType;

  const TenantsContractsDetailsTab({Key? key, required this.tabType})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (tabType) {
      case 'tenants':
        return TenantsTab();
      case 'contracts':
        return ContractsTab();
      case 'app_invitation':
        return AppInvitationTab();

      default:
        return Center(child: Text('Unknown Tab'));
    }
  }
}
