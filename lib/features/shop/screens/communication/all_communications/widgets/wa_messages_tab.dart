import 'package:flutter/material.dart';
import 'package:cartakers/features/shop/screens/communication/all_communications/table/message/wa_table_source.dart';
import 'package:cartakers/features/shop/screens/communication/all_communications/table/message/table_header.dart';
import 'package:cartakers/data/models/object_model.dart';
import 'package:cartakers/utils/constants/sizes.dart';

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
            child: WhatsAppMessageList(object: object),
          ),
        ],
      ),
    );
  }
}
