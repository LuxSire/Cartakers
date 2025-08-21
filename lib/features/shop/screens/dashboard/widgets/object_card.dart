import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/common/widgets/images/t_rounded_image.dart';
import 'package:xm_frontend/common/widgets/loaders/animation_loader.dart';
import 'package:xm_frontend/features/shop/controllers/object/object_controller.dart';
import 'package:xm_frontend/routes/routes.dart';
import 'package:xm_frontend/utils/constants/colors.dart';
import 'package:xm_frontend/utils/constants/enums.dart';
import 'package:xm_frontend/utils/constants/image_strings.dart';
import 'package:xm_frontend/utils/constants/sizes.dart';
import 'package:xm_frontend/utils/constants/text_strings.dart';
class ObjectCard extends StatelessWidget {
  const ObjectCard({super.key});
 
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ObjectController>();
   debugPrint('[ObjectCard] Constructor called');
  WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.allObjects.isEmpty) {
        controller.loadAllObjects();
        //  controller.refreshData();
      }
    });
    //WidgetsBinding.instance.addPostFrameCallback((_) {
    debugPrint('[ObjectCard] All Objects: ${controller.allObjects.length}');
    //  controller.refreshData();
    //   });

  

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
           final objects = controller.allObjects;

          if (objects.isEmpty) {
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
            itemCount: objects.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 800, // max card width
              mainAxisExtent: 200, // fixed height of each card
              crossAxisSpacing: TSizes.spaceBtwItems,
              mainAxisSpacing: TSizes.spaceBtwItems,
            ),
            itemBuilder: (context, index) {
              final object = objects[index];

              return InkWell(
                onTap: () {
                  Get.toNamed(Routes.editObject, arguments: object)?.then((
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
                            object.imgUrl!.isNotEmpty
                                ? ImageType.network
                                : ImageType.asset,
                        image:
                            object.imgUrl!.isNotEmpty
                                ? object.imgUrl!
                                : TImages.defaultImage,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              object.name ?? '',
                              style: Theme.of(context).textTheme.titleMedium!
                                  .copyWith(fontWeight: FontWeight.w700),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              object.address ?? '',
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
                                      '${object.zoning ?? 0} ${AppLocalization.of(context).translate('objects_screen.lbl_zoning').toLowerCase()}',
                                ),
                                _StatIcon(
                                  icon: Iconsax.money,
                                  label:
                                      '${object.price ?? 0}' '${object.currency ?? ''}',
                                ),
                                
                              ],
                            ),
                               const SizedBox(height: 8),
                            Wrap(
                              spacing: 12,
                              runSpacing: 4,
                              children: [
                                _StatIcon(
                                  icon: Iconsax.cards,
                                  label:
                                      '${object.city ?? 0} ${AppLocalization.of(context).translate('objects_screen.lbl_city').toLowerCase()}',
                                ),
                                _StatIcon(
                                  icon: Iconsax.map,
                                  label:
                                      '${object.country}',
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
