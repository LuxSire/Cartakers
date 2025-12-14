import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cartakers/app/localization/app_localization.dart';
import 'package:cartakers/common/widgets/loaders/loader_animation.dart';
//import 'package:xm_frontend/features/personalization/controllers/settings_controller.dart';
import 'package:cartakers/features/shop/controllers/object/object_unit_controller.dart';
import 'package:cartakers/features/shop/screens/dashboard/dialogs/assign_contract.dart';
import 'package:cartakers/utils/constants/colors.dart';
import 'package:cartakers/utils/constants/sizes.dart';

class VacantCard extends StatelessWidget {
  const VacantCard({super.key});

  @override
  Widget build(BuildContext context) {
 //   final objectId =
   //     SettingsController.instance.settings.value.selectedObjectId;
    final controller = Get.put(ObjectUnitController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          final vacantUnits = controller.allVacantUnits;

          if (vacantUnits.isEmpty) {
            return const SizedBox(
              height: 400,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [TLoaderAnimation()],
              ),
            );
          }

          return SizedBox(
            height: 400,
            child: ListView.separated(
              itemCount: vacantUnits.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final unit = vacantUnits[index];
                return Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: TSizes.sm),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              unit.unitNumber ?? 'N/A',
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.w400,
                                color: TColors.txt333333,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${AppLocalization.of(context).translate('dashboard_screen.lbl_vacant_since')} ${unit.formattedDate}',
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: TColors.txt333333,
                                  ),
                                ),
                                const SizedBox(height: TSizes.xs),
                                Text(
                                  unit.objectName ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodySmall!
                                      .copyWith(color: TColors.txt666666),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: TColors.textSecondary.withOpacity(0.5),
                                ),
                              ),
                              child: Text(
                                '${unit.floorNumber} ${AppLocalization.of(context).translate('dashboard_screen.lbl_floor')}, ${unit.pieceName}-${AppLocalization.of(context).translate('dashboard_screen.lbl_room')}',
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: TColors.txt666666,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                final result = await showDialog<bool>(
                                  context: context,
                                  barrierDismissible: false,
                                  builder:
                                      (context) => AssignContractDialog(
                                        objectId: unit.objectId!,

                                        unitNumer: unit.unitNumber ?? '',
                                        unitId: unit.id!,

                                        objectName: unit.objectName ?? '',
                                      ),
                                );

                                if (result == true) {
                                  debugPrint(
                                    'VacantCard: Assign contract dialog closed with result: $result',
                                  );
                                  controller.refreshData();
                                }
                              },

                              child: Text(
                                AppLocalization.of(context).translate(
                                  'dashboard_screen.lbl_assign_contract',
                                ),
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall!.copyWith(
                                  color: TColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: TSizes.sm),
                      ],
                    ),
                  ],
                );
              },
            ),
          );
        }),
      ],
    );
  }
}
