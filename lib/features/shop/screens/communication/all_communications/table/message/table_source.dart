import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/data/models/request_model.dart';
import 'package:xm_frontend/data/models/message_model.dart';
import 'package:xm_frontend/features/shop/controllers/communication/communication_controller.dart';
import 'package:xm_frontend/features/personalization/controllers/user_controller.dart';
import 'package:xm_frontend/features/personalization/controllers/company_controller.dart';
import 'package:xm_frontend/features/shop/controllers/object/object_controller.dart';
import 'package:xm_frontend/features/shop/screens/communication/all_communications/dialogs/view_message.dart';
import 'package:xm_frontend/routes/routes.dart';
import 'package:xm_frontend/utils/formatters/formatter.dart';
import 'package:xm_frontend/utils/helpers/helper_functions.dart';

import '../../../../../../../common/widgets/icons/table_action_icon_buttons.dart';
import '../../../../../../../utils/constants/colors.dart';
import '../../../../../../../utils/constants/sizes.dart';

class MessageRows extends DataTableSource {
  final controller = CommunicationController.instance;
  final userController = Get.find<UserController>();
  final companyController = Get.find<CompanyController>();
  final objectController = Get.find<ObjectController>(); // or use objectsList from CommunicationController

  final List<MessageModel> items;
  MessageRows(this.items);

  @override
  DataRow? getRow(int index) {
    final message = items[index];

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
          Builder(
            builder: (context) {
              final u_name = getUsernameFromMessage(message);
              return Tooltip(
                message: u_name,
                child: Text(
                  u_name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              );
            },
          ),
        ),

        /// Channels: use Chips or Icons
           DataCell(
          Builder(
            builder: (context) {
              final o_name = getObjectNameFromMessage(message);
              return Tooltip(
                message: o_name,
                child: Text(
                  o_name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              );
            },
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
  String getUsernameFromMessage(MessageModel message) {
  // If you have a list of users in userController
  debugPrint('Fetching username for message: ${message.senderId}');
  debugPrint('available users: ${userController.allItems.map((u) => u.id).toList()}');
  final user = userController.allItems.firstWhereOrNull((u) => u.id == message.senderId.toString());
  return user?.displayName ?? '—';
}

String getCompanyNameFromMessage(MessageModel message) {
  // If you have a list of companies in companyController
  final company = companyController.allItems.firstWhereOrNull((c) => c.id == message.companyId);
  return company?.name ?? '—';
}

String getObjectNameFromMessage(MessageModel message) {
  // If you have a list of objects (e.g., from CommunicationController)
  debugPrint('Fetching object names for message: ${message.id}');
  debugPrint('available objects: ${objectController.allItems.map((o) => o.id).toList()}');

  // If multiple objectIds, you can join their names
  final obj = objectController.allObjects.firstWhereOrNull((o) => o.id == message.objectId);
  return obj?.name ?? '—';
}

}
