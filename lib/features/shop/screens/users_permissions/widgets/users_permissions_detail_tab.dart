import 'package:flutter/material.dart';
import 'package:xm_frontend/features/shop/screens/user/widgets/bookings_tab.dart';
import 'package:xm_frontend/features/shop/screens/user/widgets/user_documents_tab.dart';
import 'package:xm_frontend/features/shop/screens/user/widgets/user_requests_tab.dart';
import 'package:xm_frontend/features/shop/screens/user/widgets/user_tab.dart';
import 'package:xm_frontend/features/shop/screens/users_permissions/widgets/app_invitation_tab.dart';
import 'package:xm_frontend/features/shop/screens/users_permissions/widgets/permissions_tab.dart';
import 'package:xm_frontend/features/shop/screens/users_permissions/widgets/users_tab.dart';

class UsersPermissionsDetailTab extends StatelessWidget {
  final String tabType;

  const UsersPermissionsDetailTab({Key? key, required this.tabType})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (tabType) {
      case 'users':
        return UsersTab();
      case 'permissions':
        return PermissionsTab();
      case 'app_invitation':
        return AppInvitationTab();

      default:
        return Center(child: Text('Unknown Tab'));
    }
  }
}
