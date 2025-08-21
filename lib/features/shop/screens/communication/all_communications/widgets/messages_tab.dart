import 'package:flutter/material.dart';
import 'package:xm_frontend/features/shop/screens/communication/all_communications/table/message/data_table.dart';
import 'package:xm_frontend/features/shop/screens/communication/all_communications/table/message/table_header.dart';
import 'package:xm_frontend/data/models/object_model.dart';
import 'package:xm_frontend/utils/constants/sizes.dart';

class MessagesTab extends StatelessWidget {
  const MessagesTab({super.key,this.object});

  final ObjectModel? object;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Table Header
          MessageTableHeader(),
          SizedBox(height: TSizes.spaceBtwItems),

          // Table
          Expanded(
            child: MessageTable(object: object),
          ),
        ],
      ),
    );
  }
}
