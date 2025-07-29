import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/features/shop/controllers/building/building_unit_controller.dart';
import 'package:xm_frontend/features/shop/controllers/building/building_unit_detail_controller.dart';
import 'package:xm_frontend/utils/constants/colors.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/device/device_utility.dart';
import '../../../../../../utils/helpers/helper_functions.dart';

class UnitInfo extends StatelessWidget {
  const UnitInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BuildingUnitDetailController>();

    return Obx(() {
      final unit = controller.unit.value;

      return TRoundedContainer(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalization.of(
                context,
              ).translate('edit_building_screen.lbl_unit_information'),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalization.of(
                          context,
                        ).translate('edit_building_screen.lbl_updated_on'),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: TColors.black.withOpacity(0.5),
                        ),
                      ),
                      Text(
                        unit.formattedDate,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalization.of(
                          context,
                        ).translate('edit_building_screen.lbl_floor'),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: TColors.black.withOpacity(0.5),
                        ),
                      ),
                      Text(
                        '${unit.floorNumber}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalization.of(
                          context,
                        ).translate('edit_building_screen.lbl_room'),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: TColors.black.withOpacity(0.5),
                        ),
                      ),
                      Text(
                        unit.pieceName.toString(),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: TDeviceUtils.isMobileScreen(context) ? 2 : 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalization.of(
                          context,
                        ).translate('edit_building_screen.lbl_status'),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: TColors.black.withOpacity(0.5),
                        ),
                      ),
                      TRoundedContainer(
                        radius: TSizes.cardRadiusSm,
                        padding: const EdgeInsets.symmetric(
                          vertical: TSizes.sm,
                          horizontal: TSizes.md,
                        ),
                        backgroundColor: THelperFunctions.getUnitStatusColor(
                          unit.statusId ?? 0,
                        ).withOpacity(0.1),
                        child: Text(
                          THelperFunctions.getUnitStatusText(
                            unit.statusId ?? 0,
                          ),
                          style: TextStyle(
                            color: THelperFunctions.getUnitStatusColor(
                              unit.statusId ?? 0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalization.of(context).translate(
                          'edit_building_screen.lbl_contract_reference',
                        ),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: TColors.black.withOpacity(0.5),
                        ),
                      ),
                      Text(
                        unit.contractCode?.isEmpty == true
                            ? '-'
                            : unit.contractCode ?? '-',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
