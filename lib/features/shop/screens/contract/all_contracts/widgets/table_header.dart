import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/features/shop/controllers/contract/permission_controller.dart';
import 'package:xm_frontend/features/shop/screens/contract/dialogs/contracts_filter_dialog.dart';
import 'package:xm_frontend/features/shop/screens/contract/dialogs/create_contract.dart';
import 'package:xm_frontend/features/shop/screens/user/dialogs/create_user.dart';
import 'package:xm_frontend/utils/constants/colors.dart';
import 'package:xm_frontend/utils/device/device_utility.dart';
import 'package:xm_frontend/utils/popups/loaders.dart';

class PermissionTableHeader extends StatelessWidget {
  const PermissionTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PermissionController());
    final isDesktop = TDeviceUtils.isDesktopScreen(context);
    final width = MediaQuery.of(context).size.width;

    final int objectId = controller.permissionModel.value.objectId ?? 0;

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
              // Create Contract Button
              TextButton.icon(
                onPressed: () async {
                  final result = await showDialog<bool>(
                    context: context,
                    barrierDismissible: false,
                    builder:
                        (_) => CreateContractDialog(
                          displayUnits: true,
                          objectId: objectId,
                        ), // likely a placeholder
                  );
                  if (result == true) {
                    controller.refreshData();
                  }
                },
                icon: const Icon(Iconsax.note_add, color: TColors.alterColor),
                label: Text(
                  AppLocalization.of(
                    context,
                  ).translate('permission_screen.lbl_create_new_permission'),
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
              onChanged: (value) => controller.filterItemsWithSearch(value),
              decoration: InputDecoration(
                hintText: AppLocalization.of(
                  context,
                ).translate('unit_detail_screen.lbl_search_contracts'),
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
                builder: (context) => const ContractsFilterDialog(),
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
