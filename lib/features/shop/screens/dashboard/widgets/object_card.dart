import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cartakers/app/localization/app_localization.dart';
import 'package:cartakers/app/theme/index.dart';
import 'package:cartakers/common/widgets/images/t_rounded_image.dart';
import 'package:cartakers/common/widgets/loaders/animation_loader.dart';
import 'package:cartakers/features/shop/controllers/object/object_controller.dart';
import 'package:cartakers/routes/routes.dart';
import 'package:cartakers/utils/constants/colors.dart';
import 'package:cartakers/utils/constants/enums.dart';
import 'package:cartakers/utils/constants/image_strings.dart';
import 'package:cartakers/utils/constants/sizes.dart';
import 'package:cartakers/utils/constants/text_strings.dart';
import 'package:cartakers/features/shop/controllers/contract/permission_controller.dart';
import 'package:cartakers/data/repositories/authentication/authentication_repository.dart';
import 'package:cartakers/features/shop/screens/communication/all_communications/dialogs/create_new_message.dart';
import 'package:intl/intl.dart';
import '../../../../../services/theme_service.dart';

// ...existing imports...

class ObjectCard extends StatelessWidget {
  const ObjectCard({super.key});
 
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ObjectController>();
    final p_controller = PermissionController.instance;

    debugPrint('[ObjectCard] Constructor called');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.allItems.isEmpty) {
        controller.loadAllObjects();
      }
    });
    debugPrint('[ObjectCard] All Objects: ${controller.allItems.length}');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          final objects = controller.allItems;

          if (objects.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: TAnimationLoaderWidget(
                  height: 250,
                  text: AppLocalization.of(context)
                      .translate('general_msgs.msg_no_data_found'),
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
              maxCrossAxisExtent: 800,
              mainAxisExtent: 200,
              crossAxisSpacing: TSizes.spaceBtwItems,
              mainAxisSpacing: TSizes.spaceBtwItems,
            ),
            itemBuilder: (context, index) {
              final object = objects[index];

              return InkWell(
                onTap: () {
                  if (p_controller.CheckObjectForCurrentUser(object.id ?? 0)) {
                    Get.toNamed(Routes.editObject, arguments: object)
                        ?.then((result) {
                      if (result == true) {
                        controller.refreshData();
                      }
                    });
                  } else {
                    showDialog(
                      context: Get.context!,
                      builder: (context) => CreateMessageDialog(
                        object: object,
                        subject: 'Request Access to ${object.name}',
                        message: 'Please give me access to ${object.name}',
                      ),
                    );
                    Get.snackbar(
                      'Access Denied',
                      'You do not have permission to access this object. Not yet. Make a request',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: TColors.error.withOpacity(0.1),
                      colorText: TColors.error,
                    );
                  }
                },
                borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
                child: Obx(() {
                  final themeService = Get.find<ThemeService>();
                  final bgColor = themeService.isDarkMode.value
                      ? Theme.of(context).scaffoldBackgroundColor
                      : Theme.of(context).scaffoldBackgroundColor;

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceTint
                              .withOpacity(0.3),
                          blurRadius: Theme.of(context).brightness == Brightness.dark ? 5 : 1,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TRoundedImage(
                          width: 100,
                          height: 75,
                          fit: BoxFit.cover,
                          padding: 2,
                          imageType: object.imgUrl!.isNotEmpty
                              ? ImageType.network
                              : ImageType.asset,
                          image: object.imgUrl!.isNotEmpty
                              ? object.imgUrl!
                              : TImages.defaultImage,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    object.name ?? '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    object.state ?? '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Wrap(
                                spacing: 12,
                                runSpacing: 4,
                                children: [
                                  _StatIcon(
                                    icon: Iconsax.building,
                                    label: '${object.zoning ?? ''}',
                                  ),
                                  _StatIcon(
                                    icon: Iconsax.money,
                                    label: object.price != null
                                        ? '${object.currency ?? ''} ${NumberFormat('#,##0', 'en_US').format(object.price)}'
                                        : '',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 12,
                                runSpacing: 4,
                                children: [
                                  _StatIcon(
                                    icon: Iconsax.location,
                                    label: '${object.city ?? ''}',
                                  ),
                                  _StatIcon(
                                    icon: Iconsax.map,
                                    label: '${object.country}',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 12,
                                runSpacing: 4,
                                children: [
                                  _StatIcon(
                                    icon: Iconsax.activity,
                                    label: '${object.status ?? ''}',
                                  ),
                                  _StatIcon(
                                    icon: Iconsax.bucket,
                                    label: '${object.occupancy}',
                                  ),
                                  _StatIcon(
                                    icon: Iconsax.money1,
                                    label: object.yieldGross != null
                                        ? '${object.yieldGross?.toStringAsFixed(2)}%'
                                        : '',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
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
        Icon(icon, size: 16, color: Theme.of(context).colorScheme.secondary),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: Theme.of(context).textTheme.bodyMedium!
                .copyWith(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ],
    );
  }
}