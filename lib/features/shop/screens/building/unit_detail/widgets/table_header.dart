import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/data/models/contract_model.dart';
import 'package:xm_frontend/features/shop/controllers/building/building_unit_detail_controller.dart';
import 'package:xm_frontend/features/shop/screens/contract/dialogs/create_contract.dart';
import 'package:xm_frontend/utils/constants/colors.dart';

class BuildingUnitContractTableHeader extends StatelessWidget {
  const BuildingUnitContractTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BuildingUnitDetailController());

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;

        if (isSmallScreen) {
          // Stack vertically
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextButton.icon(
                onPressed: () async {
                  final newContract = await showDialog<ContractModel>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return CreateContractDialog(
                        displayUniits: false,
                        buildingId: controller.unit.value.buildingId!,
                      );
                    },
                  );

                  if (newContract != null) {
                    controller.getUnitContracts(controller.unit.value);
                  }
                },
                icon: const Icon(Iconsax.add_circle, color: TColors.alterColor),
                label: Text(
                  AppLocalization.of(
                    context,
                  ).translate('unit_detail_screen.lbl_create_new_contract'),
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
                  ).translate('unit_detail_screen.lbl_search_contracts'),
                  prefixIcon: const Icon(Iconsax.search_normal),
                ),
              ),
            ],
          );
        } else {
          // Side by side on wide screens
          return Row(
            children: [
              TextButton.icon(
                onPressed: () async {
                  final newContract = await showDialog<ContractModel>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return CreateContractDialog(
                        displayUniits: false,
                        buildingId: controller.unit.value.buildingId!,
                      );
                    },
                  );

                  if (newContract != null) {
                    controller.getUnitContracts(controller.unit.value);
                  }
                },
                icon: const Icon(Iconsax.add_circle, color: TColors.alterColor),
                label: Text(
                  AppLocalization.of(
                    context,
                  ).translate('unit_detail_screen.lbl_create_new_contract'),
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
                    ).translate('unit_detail_screen.lbl_search_contracts'),
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
