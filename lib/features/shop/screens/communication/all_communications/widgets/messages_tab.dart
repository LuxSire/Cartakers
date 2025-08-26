import 'package:flutter/material.dart';
import 'package:xm_frontend/features/shop/screens/communication/all_communications/table/message/data_table.dart';
import 'package:xm_frontend/features/shop/screens/communication/all_communications/table/message/table_header.dart';
import 'package:xm_frontend/data/models/object_model.dart';
import 'package:xm_frontend/utils/constants/sizes.dart';
import 'package:xm_frontend/features/shop/screens/communication/all_communications/table/message/wa_table_source.dart';

class MessagesTab extends StatefulWidget {
  const MessagesTab({super.key, this.object});

  final ObjectModel? object;

  @override
  State<MessagesTab> createState() => _MessagesTabState();
}

class _MessagesTabState extends State<MessagesTab> {
  bool showCloudStyle = false;

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

          // Toggle Switch
          Row(
            children: [
              const Text('Table'),
              Switch(
                value: showCloudStyle,
                onChanged: (val) => setState(() => showCloudStyle = val),
              ),
              const Text('Clouds'),
            ],
          ),
          SizedBox(height: TSizes.spaceBtwItems),

          // Table or Cloud List
          Expanded(
            child: showCloudStyle
                ? WhatsAppMessageList(object: widget.object)
                : MessageTable(object: widget.object),
          ),
        ],
      ),
    );
  }
}