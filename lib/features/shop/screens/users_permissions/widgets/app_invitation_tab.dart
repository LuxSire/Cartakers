import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cartakers/app/localization/app_localization.dart';
import 'package:cartakers/features/personalization/models/user_model.dart';
//import 'package:cartakers/features/shop/controllers/user/user_controller.dart';

import 'package:cartakers/features/shop/screens/user/all_users/table/data_table.dart';
import 'package:cartakers/features/shop/screens/user/all_users/table2/data_table.dart';
import 'package:cartakers/features/shop/screens/user/all_users/widgets/table_header.dart';
import 'package:cartakers/features/shop/screens/user/all_users/widgets/table_header_invitation.dart';
//import 'package:cartakers/features/shop/screens/settings_managements/dialogs/edit_user.dart';
import 'package:cartakers/utils/constants/colors.dart';
import 'package:cartakers/utils/constants/sizes.dart';

class AppInvitationTab extends StatelessWidget {
  const AppInvitationTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Table Header
          UsersInvitationTableHeader(),
          SizedBox(height: TSizes.spaceBtwItems),

          // Table
          Expanded(child: UsersInvitationTable()),
        ],
      ),
    );
  }
}
