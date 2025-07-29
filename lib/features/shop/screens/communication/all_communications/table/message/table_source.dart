import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/data/models/request_model.dart';
import 'package:xm_frontend/features/shop/controllers/communication/communication_controller.dart';
import 'package:xm_frontend/features/shop/screens/communication/all_communications/dialogs/view_message.dart';
import 'package:xm_frontend/routes/routes.dart';
import 'package:xm_frontend/utils/formatters/formatter.dart';
import 'package:xm_frontend/utils/helpers/helper_functions.dart';

import '../../../../../../../common/widgets/icons/table_action_icon_buttons.dart';
import '../../../../../../../utils/constants/colors.dart';
import '../../../../../../../utils/constants/sizes.dart';

class MessageRows extends DataTableSource {
  final controller = CommunicationController.instance;

  @override
  DataRow? getRow(int index) {
    final message = controller.filteredItems[index];

    String displayDate;
    if (message.scheduledAt != null) {
      // Message is scheduled but not yet sent
      displayDate = TFormatter.formatDateTimeWithText(message.scheduledAt!);
    } else {
      // Message was sent immediately
      displayDate = TFormatter.formatDateTimeWithText(message.createdAt!);
    }

    return DataRow2(
      onTap: () async {
        final updatedMessage = await showDialog<RequestModel>(
          context: Get.context!,
          barrierDismissible: false,
          builder: (_) => ViewMessageDialog(message: message),
        );

        if (updatedMessage != null) {
          controller.refreshData();
        }
      },
      selected: controller.selectedRows[index],
      onSelectChanged:
          (value) => controller.selectedRows[index] = value ?? false,
      cells: [
        DataCell(
          Row(
            children: [
              Icon(
                message.scheduledAt != null ? Icons.schedule : Icons.send,
                size: 16,
                color:
                    message.scheduledAt != null
                        ? Colors.blueAccent
                        : Colors.green,
              ),
              const SizedBox(width: 6),
              Tooltip(
                message:
                    message.scheduledAt != null
                        ? AppLocalization.of(
                          Get.context!,
                        ).translate('general_msgs.msg_scheduled_message')
                        : AppLocalization.of(
                          Get.context!,
                        ).translate('general_msgs.msg_sent_immediately'),
                child: Text(
                  message.scheduledAt != null
                      ? TFormatter.formatDateTimeWithText(message.scheduledAt!)
                      : TFormatter.formatDateTimeWithText(message.createdAt!),
                ),
              ),
            ],
          ),
        ),

        DataCell(Text(message.title ?? '—')),

        /// Recipients: Show up to 1 or 2 entries then ellipsis
        DataCell(
          Tooltip(
            message: message.recipients
                .map(
                  (r) =>
                      r.recipientLabel ??
                      '${r.recipientType} #${r.recipientId}',
                )
                .join(', '),
            child: Text(
              _buildRecipientPreview(message.recipients),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ),

        /// Channels: use Chips or Icons
        DataCell(
          Wrap(
            spacing: TSizes.xs,
            children:
                message.channels.map((channel) {
                  return Chip(
                    label: Text(channel),
                    backgroundColor: THelperFunctions.getChannelColor(channel),
                    labelStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  );
                }).toList(),
          ),
        ),

        /// Status: badge style
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: THelperFunctions.getMessageStatusColor(
                message.statusName ?? '',
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              THelperFunctions.getMessageStatusText(message.statusId!),
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),

        /// Actions
        DataCell(
          TTableActionButtons(
            view: true,
            edit: false,
            delete: true,
            onDeletePressed: () {
              controller.confirmAndDeleteItem(message);
            },

            onViewPressed: () async {
              final updatedMessage = await showDialog<RequestModel>(
                context: Get.context!,
                barrierDismissible: false,
                builder: (_) => ViewMessageDialog(message: message),
              );

              if (updatedMessage != null) {
                controller.refreshData();
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.filteredItems.length;

  @override
  int get selectedRowCount =>
      controller.selectedRows.where((selected) => selected).length;

  /// Helpers
  String _buildRecipientPreview(List recipients) {
    final labels =
        recipients
            .map(
              (r) => r.recipientLabel ?? '${r.recipientType} #${r.recipientId}',
            )
            .toList();

    if (labels.isEmpty) return '—';
    if (labels.length == 1) return labels.first;
    if (labels.length == 2) return '${labels[0]}, ${labels[1]}';
    return '${labels[0]}, ${labels[1]}...';
  }
}
