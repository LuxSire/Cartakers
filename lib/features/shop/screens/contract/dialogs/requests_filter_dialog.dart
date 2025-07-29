import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:xm_frontend/features/shop/controllers/booking/booking_controller.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/features/shop/controllers/request/request_controller.dart';
import 'package:xm_frontend/utils/constants/colors.dart';

class RequestsFilterDialog extends StatelessWidget {
  const RequestsFilterDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // final controller = Get.find<RequestController>();
    final controller = Get.find<RequestController>(tag: 'contract_requests');

    final theme = Theme.of(context);

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
          //  crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar for request Filter
            // TextFormField(
            //   controller: controller.searchController,
            //   onChanged: (query) => controller.filterRequests(query),
            //   decoration: InputDecoration(
            //     hintText: AppLocalization.of(
            //       context,
            //     ).translate('general_msgs.msg_search_request'),
            //     prefixIcon: const Icon(Icons.search),
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(8.0),
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 16.0),

            // Date Pickers for start and end date
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => _buildDatePicker(
                      context,
                      controller.startDate,
                      AppLocalization.of(
                        context,
                      ).translate('general_msgs.msg_start_date'),
                      controller.clearStartDate, // Clear start date method
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Obx(
                    () => _buildDatePicker(
                      context,
                      controller.endDate,
                      AppLocalization.of(
                        context,
                      ).translate('general_msgs.msg_end_date'),
                      controller.clearEndDate, // Clear end date method
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Status Filter Dropdown
            Obx(() {
              final statusMap = controller.getTranslatedRequestStatuses(
                context,
              );
              return DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButtonFormField<int>(
                    isExpanded:
                        true, // Makes the dropdown button expand to match parent width
                    value: controller.selectedStatusId.value,
                    onChanged: (value) {
                      if (value != null) {
                        controller.selectedStatusId.value = value;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: AppLocalization.of(
                        context,
                      ).translate('general_msgs.msg_status'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ), // adjust horizontal here
                    ),
                    items:
                        statusMap.entries.map((entry) {
                          return DropdownMenuItem<int>(
                            value: entry.key,
                            child: Text(entry.value),
                          );
                        }).toList(),
                  ),
                ),
              );
            }),

            const SizedBox(height: 16.0),

            // Request Type Dropdown
            Obx(() {
              return DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButtonFormField<int>(
                    isExpanded: true,
                    value: controller.selectedRequestTypeId.value,
                    onChanged: (value) {
                      if (value != null) {
                        controller.selectedRequestTypeId.value = value;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: AppLocalization.of(
                        context,
                      ).translate('create_request_screen.lbl_request_type'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                    items: [
                      DropdownMenuItem<int>(
                        value: 0,
                        child: Text(
                          AppLocalization.of(
                            context,
                          ).translate("general_msgs.msg_all"),
                        ),
                      ),
                      ...controller.requestTypes.map(
                        (type) => DropdownMenuItem<int>(
                          value: type.id,
                          child: Text(type.name),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 18.0),

            // Apply Filter and Clear Filter Buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      // Clear the filters
                      controller.clearFilters();
                      Navigator.pop(context); // Close the dialog
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
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 20,
                      ),
                    ),

                    onPressed: () {
                      controller.applyFilters(
                        controller.selectedStatusId.value,
                        controller.selectedRequestTypeId.value,
                        controller.selectedBuildingFilterId.value,
                        controller.startDate.value,
                        controller.endDate.value,
                      );
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

  // Helper method for creating the date picker widget

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
                if (onClear != null) {
                  onClear(); // Clear date in the controller
                }
              },
            ),
        ],
      ),
      onPressed: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: dateController.value ?? DateTime.now(),
          firstDate: DateTime(2025),
          lastDate: DateTime(2050),
        );
        if (picked != null) {
          dateController.value = picked;
        }
      },
    );
  }
}
