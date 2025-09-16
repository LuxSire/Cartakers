import 'package:flutter/material.dart';
import 'package:xm_frontend/features/shop/screens/user/widgets/bookings_tab.dart';
import 'package:xm_frontend/features/shop/screens/user/widgets/user_documents_tab.dart';
import 'package:xm_frontend/features/shop/screens/user/widgets/user_requests_tab.dart';
import 'package:xm_frontend/features/shop/screens/user/widgets/user_tab.dart';
import 'package:xm_frontend/features/shop/screens/users_permissions/widgets/companies_tab.dart';
import 'package:xm_frontend/features/shop/screens/users_permissions/widgets/app_invitation_tab.dart';
import 'package:xm_frontend/features/shop/screens/users_permissions/widgets/permissions_tab.dart';
import 'package:xm_frontend/features/shop/screens/users_permissions/widgets/users_tab.dart';
import 'package:xm_frontend/features/personalization/controllers/user_controller.dart';
import 'package:get/get.dart';

class UsersPermissionsDetailTab extends StatelessWidget {
  final String tabType;

  const UsersPermissionsDetailTab({Key? key, required this.tabType})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    switch (tabType) {
      
      case 'companies':
        return CompaniesTab();
      case 'users':
         userController.selectedRoleId.value = 0;
        return UsersTab();
      case 'pendingusers':
      
        userController.selectedRoleId.value = 4;
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
