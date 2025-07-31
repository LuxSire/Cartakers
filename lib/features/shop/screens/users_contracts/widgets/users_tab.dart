import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/features/personalization/models/user_model.dart';
import 'package:xm_frontend/features/shop/controllers/user/user_controller.dart';
import 'package:xm_frontend/features/shop/screens/user/all_users/table/data_table.dart';
import 'package:xm_frontend/features/shop/screens/user/all_users/widgets/table_header.dart';
import 'package:xm_frontend/features/shop/screens/user/dialogs/edit_user.dart';
import 'package:xm_frontend/utils/constants/colors.dart';

import 'package:xm_frontend/utils/constants/sizes.dart';

class UsersTab extends StatelessWidget {
  const UsersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          // Table Header
          UserTableHeader(),
          SizedBox(height: TSizes.spaceBtwItems),

          // Table
          UsersTable(),
        ],
      ),
    );
  }
}
