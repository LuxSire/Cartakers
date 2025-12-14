import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:cartakers/app/localization/app_localization.dart';
import 'package:cartakers/features/shop/controllers/request/request_controller.dart';
//import 'package:cartakers/features/shop/controllers/user/user_controller.dart';
import 'package:cartakers/features/personalization/controllers/user_controller.dart';
import 'package:cartakers/utils/constants/colors.dart';
import 'package:cartakers/utils/device/device_utility.dart';
class UsersFilterDialog extends StatelessWidget {
  const UsersFilterDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserController>();
    final theme = Theme.of(context);

    final RxInt tempStatusId = controller.selectedStatusId.value.obs;
    final RxInt tempObjectFilterId =
    controller.selectedObjectId.value.obs;
    final Rx<DateTime?> tempStartDate = controller.startDate.value.obs;
    final Rx<DateTime?> tempEndDate = controller.endDate.value.obs;

    return AlertDialog(
      backgroundColor: TColors.white,
      title: Text(
        AppLocalization.of(
          context,
        ).translate('general_msgs.msg_filter_options'),
        style: theme.textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => _buildDatePicker(
                      context,
                      tempStartDate,
                      AppLocalization.of(
                        context,
                      ).translate('general_msgs.msg_start_date'),
                      () => tempStartDate.value = null,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Obx(
                    () => _buildDatePicker(
                      context,
                      tempEndDate,
                      AppLocalization.of(
                        context,
                      ).translate('general_msgs.msg_end_date'),
                      () => tempEndDate.value = null,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),


            const SizedBox(height: 16),

            const SizedBox(height: 18),

            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      // Reset filters in UI and apply empty state
                      controller.applyFilters(-1, 0, null, null);

                      // Clear internal state and flags
                      controller.clearFilters();
                      controller.filtersApplied.value = true;

                      // Close dialog
                      Navigator.pop(context);
                    },
                    child: Text(
                      AppLocalization.of(
                        context,
                      ).translate('general_msgs.msg_clear_filters'),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: TColors.primary,
                      foregroundColor: TColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      // Apply the filters
                      controller.applyFilters(
                        tempStatusId.value,
                        tempObjectFilterId.value,
                        tempStartDate.value,
                        tempEndDate.value,
                      );
                      controller.filtersApplied.value = true;
                      Navigator.pop(context);
                    },
                    child: Text(
                      AppLocalization.of(
                        context,
                      ).translate('general_msgs.msg_apply_filters'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker(
    BuildContext context,
    Rx<DateTime?> dateController,
    String labelText,
    Function? onClear,
  ) {
    return TextButton.icon(
      icon: const Icon(Iconsax.calendar, size: 20),
      label: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              dateController.value == null
                  ? labelText
                  : DateFormat('dd.MM.yyyy').format(dateController.value!),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (dateController.value != null)
            IconButton(
              icon: const Icon(Icons.clear, size: 20, color: Colors.red),
              onPressed: () {
                dateController.value = null;
                if (onClear != null) onClear();
              },
            ),
        ],
      ),
      onPressed: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: dateController.value ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2050),
        );
        if (picked != null) dateController.value = picked;
      },
    );
  }
}
