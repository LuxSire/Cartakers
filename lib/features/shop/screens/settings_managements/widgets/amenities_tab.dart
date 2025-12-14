import 'package:flutter/material.dart';
import 'package:cartakers/features/shop/screens/user/all_users/widgets/table_header.dart';

import 'package:cartakers/utils/constants/sizes.dart';

class AmenitiesTab extends StatelessWidget {
  const AmenitiesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          // Table Header
          UserTableHeader(),
          SizedBox(height: TSizes.spaceBtwItems),
        ],
      ),
    );
  }
}
