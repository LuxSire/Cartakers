import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xm_frontend/app.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/features/shop/controllers/building/building_controller.dart';
import 'package:xm_frontend/features/shop/screens/building/all_buildings/dialogs/create_building.dart';
import 'package:xm_frontend/routes/routes.dart';
import 'package:xm_frontend/utils/constants/colors.dart';
import 'package:xm_frontend/utils/popups/loaders.dart';

import '../../../../../../utils/device/device_utility.dart';

class BuildingTableHeader extends StatelessWidget {
  const BuildingTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BuildingController());

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
                    builder: (_) => const CreateBuildingDialog(),
                  );
                  if (result == true) {
                    controller.refreshData();
                  }
                },
                icon: const Icon(Iconsax.add_circle, color: TColors.alterColor),
                label: Text(
                  AppLocalization.of(
                    context,
                  ).translate('buildings_screen.lbl_create_new_building'),
                  style: const TextStyle(color: TColors.alterColor),
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
                icon: const Icon(Iconsax.refresh, color: TColors.alterColor),
                label: Text(
                  AppLocalization.of(
                    context,
                  ).translate('general_msgs.msg_refresh'),
                  style: const TextStyle(color: TColors.alterColor),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.searchTextController,
                onChanged: (query) => controller.searchQuery(query),
                decoration: InputDecoration(
                  hintText: AppLocalization.of(
                    context,
                  ).translate('buildings_screen.lbl_search_buildings'),
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
                    builder: (_) => const CreateBuildingDialog(),
                  );
                  if (result == true) {
                    controller.refreshData();
                  }
                },
                icon: const Icon(Iconsax.add_circle, color: TColors.alterColor),
                label: Text(
                  AppLocalization.of(
                    context,
                  ).translate('buildings_screen.lbl_create_new_building'),
                  style: const TextStyle(color: TColors.alterColor),
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
                icon: const Icon(Iconsax.refresh, color: TColors.alterColor),
                label: Text(
                  AppLocalization.of(
                    context,
                  ).translate('general_msgs.msg_refresh'),
                  style: const TextStyle(color: TColors.alterColor),
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
                    ).translate('buildings_screen.lbl_search_buildings'),
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
