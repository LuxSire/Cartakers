import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/features/shop/controllers/communication/communication_controller.dart';
import 'package:xm_frontend/features/shop/controllers/user/user_controller.dart';
import 'package:xm_frontend/features/shop/screens/communication/all_communications/dialogs/create_new_message.dart';
import 'package:xm_frontend/features/shop/screens/communication/all_communications/dialogs/messages_filter_dialog.dart';
import 'package:xm_frontend/features/shop/screens/user/dialogs/create_user.dart';
import 'package:xm_frontend/features/shop/screens/user/dialogs/users_filter_dialog.dart';
import 'package:xm_frontend/utils/constants/colors.dart';
import 'package:xm_frontend/utils/device/device_utility.dart';
import 'package:xm_frontend/utils/popups/loaders.dart';

class MessageTableHeader extends StatelessWidget {
  const MessageTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CommunicationController());
    final isDesktop = TDeviceUtils.isDesktopScreen(context);
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Wrap(
        spacing: 16,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceBetween,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              TextButton.icon(
                onPressed: () async {
                  final result = await showDialog<bool>(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const CreateMessageDialog(),
                  );
                  if (result == true) {
                    controller.refreshData();
                  }
                },
                icon: const Icon(
                  Iconsax.message_add,
                  color: TColors.alterColor,
                ),
                label: Text(
                  AppLocalization.of(
                    context,
                  ).translate('communication_screen.lbl_create_new_message'),
                  style: const TextStyle(color: TColors.alterColor),
                ),
              ),

              // Refresh Button
              TextButton.icon(
                onPressed: () {
                  controller.refreshData();
                  TLoaders.successSnackBar(
                    title: AppLocalization.of(
                      context,
                    ).translate('general_msgs.msg_info'),
                    message: AppLocalization.of(
                      context,
                    ).translate('general_msgs.msg_data_refreshed'),
                  );
                },
                icon: const Icon(Iconsax.refresh, color: TColors.alterColor),
                label: Text(
                  AppLocalization.of(
                    context,
                  ).translate('general_msgs.msg_refresh'),
                  style: const TextStyle(color: TColors.alterColor),
                ),
              ),
            ],
          ),

          // Search Field
          SizedBox(
            width: isDesktop ? 350 : width - 32,
            child: TextFormField(
              controller: controller.searchTextController,
              onChanged: (value) => controller.searchQuery(value),
              decoration: InputDecoration(
                hintText: AppLocalization.of(
                  context,
                ).translate('communication_screen.lbl_search_messages'),
                prefixIcon: const Icon(Iconsax.search_normal),
                border: const OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),

          TextButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const MessagesFilterDialog(),
              );
            },
            icon: const Icon(Icons.filter_list, size: 20),
            label: Text(
              AppLocalization.of(context).translate('general_msgs.msg_filters'),
              style: TextStyle(color: TColors.primary),
            ),
          ),

          Obx(() {
            if (!controller.filtersApplied.value) return SizedBox.shrink();

            final filters = controller.getActiveFilters();
            if (filters.isEmpty) return const SizedBox.shrink();

            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  filters.map((filter) {
                    final label = filter.keys.first;
                    final onRemove = filter.values.first;
                    return Chip(
                      label: Text(label),
                      backgroundColor: TColors.primary.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.grey.shade100),
                      ),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: onRemove,
                    );
                  }).toList(),
            );
          }),
        ],
      ),
    );
  }
}
