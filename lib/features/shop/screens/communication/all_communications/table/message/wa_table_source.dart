import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/features/shop/controllers/communication/communication_controller.dart';
import 'package:xm_frontend/features/personalization/controllers/user_controller.dart';
import 'package:xm_frontend/utils/formatters/formatter.dart';
import 'package:xm_frontend/data/models/object_model.dart';

class WhatsAppMessageList extends StatelessWidget {
  WhatsAppMessageList({super.key, this.object});

  final ObjectModel? object;
  final controller = CommunicationController.instance;
  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    final currentUserId = userController.user.value.id?.toString();
 
    controller.selectedObjectId.value = object?.id ?? -1;
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      itemCount: controller.filteredItems.length,
      itemBuilder: (context, index) {
        final message = controller.filteredItems[index];
        final isMe = message.senderId.toString() == currentUserId;
        final isOwner=message.senderId.toString()==object?.owner;

        return Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.85, // bigger bubble
              minWidth: 220,
            ),
            decoration: BoxDecoration(
              color: isMe
                  ? Theme.of(context).primaryColorLight
                  : Color.fromARGB(255, 186, 191, 198), // dark blue for others
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isMe ? 16 : 0),
                bottomRight: Radius.circular(isMe ? 0 : 16),
              ),
            ),
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if ((message.title ?? '').isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      message.title ?? '',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isMe ? Colors.black : Colors.lightGreen,
                          ),
                    ),
                  ),
                Text(
                  message.content ?? '',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: isMe ? Colors.black : Colors.lightGreen,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  TFormatter.formatDateTimeWithText(
                      message.createdAt ?? message.scheduledAt!),
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: isMe ? Colors.black : Colors.lightGreen),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}