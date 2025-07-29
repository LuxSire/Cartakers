import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/features/personalization/models/user_model.dart';
import 'package:xm_frontend/features/shop/controllers/tenant/tenant_controller.dart';
import 'package:xm_frontend/features/shop/screens/tenant/all_tenants/table/data_table.dart';
import 'package:xm_frontend/features/shop/screens/tenant/all_tenants/table2/data_table.dart';
import 'package:xm_frontend/features/shop/screens/tenant/all_tenants/widgets/table_header.dart';
import 'package:xm_frontend/features/shop/screens/tenant/all_tenants/widgets/table_header_invitation.dart';
import 'package:xm_frontend/features/shop/screens/tenant/dialogs/edit_tenant.dart';
import 'package:xm_frontend/utils/constants/colors.dart';

import 'package:xm_frontend/utils/constants/sizes.dart';

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
          TenantInvitationTableHeader(),
          SizedBox(height: TSizes.spaceBtwItems),

          // Table
          Expanded(child: TenantsInvitationTable()),
        ],
      ),
    );
  }
}
