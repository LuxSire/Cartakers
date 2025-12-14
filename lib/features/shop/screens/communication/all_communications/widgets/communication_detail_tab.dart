import 'package:flutter/material.dart';
import 'package:cartakers/features/shop/screens/communication/all_communications/widgets/messages_tab.dart';
import 'package:cartakers/features/shop/screens/user/widgets/bookings_tab.dart';
import 'package:cartakers/features/shop/screens/user/widgets/user_documents_tab.dart';
import 'package:cartakers/features/shop/screens/user/widgets/user_requests_tab.dart';
import 'package:cartakers/features/shop/screens/user/widgets/user_tab.dart';
import 'package:cartakers/features/shop/screens/users_permissions/widgets/permissions_tab.dart';
import 'package:cartakers/features/shop/screens/users_permissions/widgets/users_tab.dart';
import 'package:cartakers/data/models/object_model.dart';

class CommunicationDetailsTab extends StatelessWidget {
  final String tabType;
  final ObjectModel? object;

  const CommunicationDetailsTab({super.key, required this.tabType,this.object});

  @override
  Widget build(BuildContext context) {
    switch (tabType) {
      case 'messages':
        return MessagesTab(object: object);
      case 'permissions':
        return PermissionsTab();

      default:
        return Center(child: Text('Unknown Tab'));
    }
  }
}
