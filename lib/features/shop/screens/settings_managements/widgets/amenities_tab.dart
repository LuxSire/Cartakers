import 'package:flutter/material.dart';
import 'package:xm_frontend/features/shop/screens/tenant/all_tenants/widgets/table_header.dart';

import 'package:xm_frontend/utils/constants/sizes.dart';

class AmenitiesTab extends StatelessWidget {
  const AmenitiesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          // Table Header
          TenantTableHeader(),
          SizedBox(height: TSizes.spaceBtwItems),
        ],
      ),
    );
  }
}
