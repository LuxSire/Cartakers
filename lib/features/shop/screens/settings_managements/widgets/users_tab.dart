import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cartakers/features/personalization/controllers/user_controller.dart';
import 'package:cartakers/features/shop/screens/settings_managements/table/users/data_table.dart';
import 'package:cartakers/features/shop/screens/settings_managements/table/users/table_header.dart';

import 'package:cartakers/utils/constants/sizes.dart';

class UsersTab extends StatelessWidget {
  const UsersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserTableHeader(),
          SizedBox(height: TSizes.spaceBtwItems),
          Expanded(child: UsersTable()),
        ],
      ),
    );
  }
}
