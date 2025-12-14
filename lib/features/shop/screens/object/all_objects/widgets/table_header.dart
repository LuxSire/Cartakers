import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cartakers/app.dart';
import 'package:cartakers/app/localization/app_localization.dart';
import 'package:cartakers/features/shop/controllers/object/object_controller.dart';
import 'package:cartakers/features/shop/screens/object/all_objects/dialogs/create_object.dart';
import 'package:cartakers/routes/routes.dart';
import 'package:cartakers/utils/constants/colors.dart';
import 'package:cartakers/utils/popups/loaders.dart';

import '../../../../../../utils/device/device_utility.dart';

class ObjectTableHeader extends StatelessWidget {
  const ObjectTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ObjectController());

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;

        if (isSmallScreen) {
          // Stack vertically on small screens
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextButton.icon(
                onPressed: () async {
                  final result = await showDialog<bool>(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const CreateObjectDialog(),
                  );
                  if (result == true) {
                    controller.refreshData();
                  }
                },
                icon: const Icon(Iconsax.add_circle, color: TColors.buttonPrimary),
                label: Text(
                  AppLocalization.of(
                    context,
                  ).translate('objects_screen.lbl_create_new_object'),
                  style: const TextStyle(color: TColors.buttonPrimary),
                ),
              ),
              const SizedBox(height: 12),
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
                icon: const Icon(Iconsax.refresh, color: TColors.buttonPrimary),
                label: Text(
                  AppLocalization.of(
                    context,
                  ).translate('general_msgs.msg_refresh'),
                  style: const TextStyle(color: TColors.buttonPrimary),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.searchTextController,
                onChanged: (query) => controller.filterItemsWithSearch(query),
                decoration: InputDecoration(
                  hintText: AppLocalization.of(
                    context,
                  ).translate('objects_screen.lbl_search_objects'),
                  prefixIcon: const Icon(Iconsax.search_normal),
                ),
              ),
            ],
          );
        } else {
          // Side by side on large screens
          return Row(
            children: [
              TextButton.icon(
                onPressed: () async {
                  final result = await showDialog<bool>(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const CreateObjectDialog(),
                  );
                  if (result == true) {
                    controller.loadAllObjects();
                  }
                },
                icon: const Icon(Iconsax.add_circle, color: TColors.buttonPrimary),
                label: Text(
                  AppLocalization.of(
                    context,
                  ).translate('objects_screen.lbl_create_new_object'),
                  style: const TextStyle(color: TColors.buttonPrimary),
                ),
              ),
              const SizedBox(width: 16),
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
                icon: const Icon(Iconsax.refresh, color: TColors.buttonPrimary),
                label: Text(
                  AppLocalization.of(
                    context,
                  ).translate('general_msgs.msg_refresh'),
                  style: const TextStyle(color: TColors.buttonPrimary),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: controller.searchTextController,
                  onChanged: (query) => controller.searchQuery(query),
                  decoration: InputDecoration(
                    hintText: AppLocalization.of(
                      context,
                    ).translate('objects_screen.lbl_search_objects'),
                    prefixIcon: const Icon(Iconsax.search_normal),
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
