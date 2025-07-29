import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/common/widgets/images/t_rounded_image.dart';
import 'package:xm_frontend/common/widgets/loaders/animation_loader.dart';
import 'package:xm_frontend/features/shop/controllers/building/building_controller.dart';
import 'package:xm_frontend/routes/routes.dart';
import 'package:xm_frontend/utils/constants/colors.dart';
import 'package:xm_frontend/utils/constants/enums.dart';
import 'package:xm_frontend/utils/constants/image_strings.dart';
import 'package:xm_frontend/utils/constants/sizes.dart';

class BuildingCard extends StatelessWidget {
  const BuildingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BuildingController());

    //WidgetsBinding.instance.addPostFrameCallback((_) {
    controller.loadAllBuildings();
    //  controller.refreshData();
    //   });

    final buildingList = controller.allItems;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          final buildings = buildingList;

          if (buildings.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: TAnimationLoaderWidget(
                  height: 250,
                  text: AppLocalization.of(
                    context,
                  ).translate('general_msgs.msg_no_data_found'),
                  animation: TImages.noDataIllustration,
                ),
              ),
            );
          }

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: buildings.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 800, // max card width
              mainAxisExtent: 100, // fixed height of each card
              crossAxisSpacing: TSizes.spaceBtwItems,
              mainAxisSpacing: TSizes.spaceBtwItems,
            ),
            itemBuilder: (context, index) {
              final building = buildings[index];

              return InkWell(
                onTap: () {
                  Get.toNamed(Routes.editBuilding, arguments: building)?.then((
                    result,
                  ) {
                    if (result == true) {
                      controller.refreshData();
                    }
                  });
                },
                borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
                    color: TColors.grey.withOpacity(0.1),
                    boxShadow: [
                      BoxShadow(
                        color: TColors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TRoundedImage(
                        width: 75,
                        height: 75,
                        fit: BoxFit.cover,
                        padding: 2,
                        imageType:
                            building.imgUrl!.isNotEmpty
                                ? ImageType.network
                                : ImageType.asset,
                        image:
                            building.imgUrl!.isNotEmpty
                                ? building.imgUrl!
                                : TImages.defaultImage,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              building.name ?? '',
                              style: Theme.of(context).textTheme.titleMedium!
                                  .copyWith(fontWeight: FontWeight.w700),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              building.address ?? '',
                              style: Theme.of(context).textTheme.bodySmall!
                                  .copyWith(color: TColors.txt666666),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 12,
                              runSpacing: 4,
                              children: [
                                _StatIcon(
                                  icon: Iconsax.building,
                                  label:
                                      '${building.totalUnits ?? 0} ${AppLocalization.of(context).translate('buildings_screen.lbl_units').toLowerCase()}',
                                ),
                                _StatIcon(
                                  icon: Iconsax.profile_2user,
                                  label:
                                      '${building.totalTenants ?? 0} ${AppLocalization.of(context).translate('tenants_screen.lbl_tenants').toLowerCase()}',
                                ),
                                _StatIcon(
                                  icon: Iconsax.document,
                                  label:
                                      '${building.totalContracts ?? 0} ${AppLocalization.of(context).translate('create_contract_screen.lbl_contracts').toLowerCase()}',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ],
    );
  }
}

class _StatIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: TColors.black.withOpacity(0.6)),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
      ],
    );
  }
}
