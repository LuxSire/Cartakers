import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/features/shop/controllers/object/object_unit_controller.dart';
import 'package:xm_frontend/features/shop/controllers/object/object_unit_detail_controller.dart';
import 'package:xm_frontend/features/shop/controllers/contract/permission_controller.dart';
import 'package:xm_frontend/features/shop/screens/user/dialogs/view_user.dart';
import 'package:xm_frontend/utils/popups/loaders.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';

class UnitUsers extends StatelessWidget {
  const UnitUsers({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final detailController = ObjectUnitDetailController.instance;

      final unitFromParent = Get.find<ObjectUnitController>().unit.value;

      final contractController = Get.put(PermissionController());

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (unitFromParent.id != null &&
            detailController.unit.value.id != unitFromParent.id) {
          detailController.unit.value = unitFromParent;
          detailController.getUsersOfCurrentUnit();
        }
      });

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TRoundedContainer(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalization.of(context).translate(
                        'unit_detail_screen.lbl_users_on_active_contract',
                      ),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    // TextButton.icon(
                    //   onPressed: () {
                    //     // Add tenant logic
                    //   },
                    //   icon: const Icon(Icons.add),
                    //   label: Text(
                    //     AppLocalization.of(
                    //       context,
                    //     ).translate('dashboard_screen.lbl_add_tenant'),
                    //   ),
                    // ),
                  ],
                ),

                const SizedBox(height: TSizes.spaceBtwSections),

                // Tenants List
                Obx(() {
                  final users = detailController.allUsers;

                  if (users.isEmpty) {
                    return Text(
                      AppLocalization.of(
                        context,
                      ).translate('unit_detail_screen.lbl_no_users_found'),
                      style: Theme.of(context).textTheme.bodyMedium,
                    );
                  }

                  return Column(
                    children:
                        users.map((user) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: TSizes.spaceBtwItems,
                            ),
                            child: Row(
                              children: [
                                TRoundedImage(
                                  width: 60,
                                  height: 60,
                                  padding: 2,
                                  fit: BoxFit.cover,
                                  backgroundColor: TColors.primaryBackground,
                                  image:
                                      user.profilePicture.isNotEmpty
                                          ? user.profilePicture
                                          : TImages.user,
                                  imageType:
                                      user.profilePicture.isNotEmpty
                                          ? ImageType.network
                                          : ImageType.asset,
                                ),
                                const SizedBox(width: TSizes.spaceBtwItems),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user.fullName,
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.titleLarge,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      Text(
                                        user.email,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium!.copyWith(
                                          color: TColors.black.withOpacity(0.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  offset: const Offset(0, 40),
                                  color: Colors.white,
                                  onSelected: (value) async {
                                    if (value == 'view') {
                                      // View handler

                                      final result = await showDialog<bool>(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return ViewUserDialog(
                                            user: user,
                                            contractCode:
                                                detailController
                                                    .unit
                                                    .value
                                                    .contractCode,
                                          );
                                        },
                                      );
                                    } else if (value == 'remove') {
                                      if (detailController
                                              .unit
                                              .value
                                              .userCount! <
                                          2) {
                                        TLoaders.warningSnackBar(
                                          title: AppLocalization.of(
                                            Get.context!,
                                          ).translate(
                                            'general_msgs.msg_warning',
                                          ),
                                          message: AppLocalization.of(
                                            Get.context!,
                                          ).translate(
                                            'unit_detail_screen.lbl_cannot_remove_last_user',
                                          ),
                                        );
                                        return;
                                      }

                                      // Remove handler
                                      final result = await contractController
                                          .removeUserFromObject(
                                            unitFromParent.currentContractId!,
                                            int.parse(user.id!),
                                          );

                                      if (result) {
                                        detailController.isDataUpdated.value =
                                            true;
                                        detailController.unit.update((u) {
                                          u?.userCount = u.userCount! - 1;
                                          u?.updatedAt = DateTime.now();

                                          u?.userNames = u.userNames!
                                              .replaceAll(
                                                '${user.fullName},',
                                                '',
                                              )
                                              .replaceAll(
                                                ', ${user.fullName}',
                                                '',
                                              );
                                        });

                                        debugPrint(
                                          'User removed successfully: ${detailController.unit.value.userNames}',
                                        );
                                        //getUnitContracts
                                        detailController.getUsersOfCurrentUnit();
                                        detailController
                                            .getUsersOfCurrentUnit();

                                        // refresh the list of users
                                      }
                                    }
                                  },
                                  itemBuilder:
                                      (context) => [
                                        PopupMenuItem(
                                          value: 'view',
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.person,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                AppLocalization.of(
                                                  Get.context!,
                                                ).translate(
                                                  'general_msgs.msg_view_details',
                                                ),
                                                style:
                                                    Theme.of(
                                                      context,
                                                    ).textTheme.bodyMedium,
                                              ),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 'remove',
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.close,
                                                color: Colors.red,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                AppLocalization.of(
                                                  Get.context!,
                                                ).translate(
                                                  'general_msgs.msg_remove',
                                                ),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color: Colors.red,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                  icon: const Icon(Icons.more_vert),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwSections),
        ],
      );
    });
  }
}
