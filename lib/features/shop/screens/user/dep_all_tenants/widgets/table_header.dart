import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cartakers/app/localization/app_localization.dart';
//import 'package:cartakers/features/shop/controllers/user/user_controller.dart';
import 'package:cartakers/features/personalization/controllers/user_controller.dart';
import 'package:cartakers/features/shop/screens/user/dialogs/create_user.dart';
import 'package:cartakers/features/shop/screens/user/dialogs/users_filter_dialog.dart';
import 'package:cartakers/utils/constants/colors.dart';
import 'package:cartakers/utils/device/device_utility.dart';
import 'package:cartakers/utils/popups/loaders.dart';

class TenantTableHeader extends StatelessWidget {
  const TenantTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserController>();
    final isDesktop = TDeviceUtils.isDesktopScreen(context);
    final width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
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
                  // Create Tenant Button
                  TextButton.icon(
                    onPressed: () async {
                      final result = await showDialog<bool>(
                        context: context,
                        barrierDismissible: false,
                        builder:
                            (_) => const CreateUserDialog(
                              displayObjects: true,
                            ),
                      );
                      if (result == true) {
                        controller.refreshData();
                      }
                    },
                    icon: const Icon(
                      Iconsax.profile_add,
                      color: TColors.alterColor,
                    ),
                    label: Text(
                      AppLocalization.of(
                        context,
                      ).translate('tenants_screen.lbl_create_new_tenant'),
                      style: const TextStyle(color: TColors.alterColor),
                    ),
                  ),

                  // Import Tenants Button
                  // TextButton.icon(
                  //   onPressed: () async {
                  //     TLoaders.successSnackBar(
                  //       title: AppLocalization.of(
                  //         context,
                  //       ).translate('general_msgs.msg_info'),
                  //       message: AppLocalization.of(
                  //         context,
                  //       ).translate('general_msgs.msg_new_feature_coming_soon'),
                  //     );
                  //   },
                  //   icon: const Icon(Iconsax.import, color: TColors.alterColor),
                  //   label: Text(
                  //     AppLocalization.of(
                  //       context,
                  //     ).translate('tenants_screen.lbl_import_tenants'),
                  //     style: const TextStyle(color: TColors.alterColor),
                  //   ),
                  // ),

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
                    icon: const Icon(
                      Iconsax.refresh,
                      color: TColors.alterColor,
                    ),
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
                    ).translate('tenants_screen.lbl_search_tenants'),
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
                    builder: (context) => const UsersFilterDialog(),
                  );
                },
                icon: const Icon(Icons.filter_list, size: 20),
                label: Text(
                  AppLocalization.of(
                    context,
                  ).translate('general_msgs.msg_filters'),
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
        ),
      ],
    );
  }
}
