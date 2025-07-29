import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/common/widgets/images/t_circular_image.dart';
import 'package:xm_frontend/data/models/unit_model.dart';
import 'package:xm_frontend/features/shop/controllers/building/building_unit_controller.dart';
import 'package:xm_frontend/features/shop/controllers/building/building_unit_detail_controller.dart';
import 'package:xm_frontend/features/shop/controllers/contract/contract_controller.dart';
import 'package:xm_frontend/features/shop/screens/tenant/dialogs/view_tenant.dart';
import 'package:xm_frontend/utils/popups/loaders.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';

class UnitTenants extends StatelessWidget {
  const UnitTenants({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final detailController = BuildingUnitDetailController.instance;

      final unitFromParent = Get.find<BuildingUnitController>().unit.value;

      final contractController = Get.put(ContractController());

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (unitFromParent.id != null &&
            detailController.unit.value.id != unitFromParent.id) {
          detailController.unit.value = unitFromParent;
          detailController.getTenantsOfCurrentUnit();
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
                        'unit_detail_screen.lbl_tenants_on_active_contract',
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
                  final tenants = detailController.allTenants;

                  if (tenants.isEmpty) {
                    return Text(
                      AppLocalization.of(
                        context,
                      ).translate('unit_detail_screen.lbl_no_tenants_found'),
                      style: Theme.of(context).textTheme.bodyMedium,
                    );
                  }

                  return Column(
                    children:
                        tenants.map((tenant) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: TSizes.spaceBtwItems,
                            ),
                            child: Row(
                              children: [
                                TCircularImage(
                                  width: 60,
                                  height: 60,
                                  padding: 2,
                                  fit: BoxFit.cover,
                                  backgroundColor: TColors.primaryBackground,
                                  image:
                                      tenant.profilePicture.isNotEmpty
                                          ? tenant.profilePicture
                                          : TImages.user,
                                  imageType:
                                      tenant.profilePicture.isNotEmpty
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
                                        tenant.fullName,
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.titleLarge,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      Text(
                                        tenant.email,
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
                                          return ViewTenantDialog(
                                            tenant: tenant,
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
                                              .tenantCount! <
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
                                            'unit_detail_screen.lbl_cannot_remove_last_tenant',
                                          ),
                                        );
                                        return;
                                      }

                                      // Remove handler
                                      final result = await contractController
                                          .removeTenantFromContract(
                                            unitFromParent.currentContractId!,
                                            int.parse(tenant.id!),
                                          );

                                      if (result) {
                                        detailController.isDataUpdated.value =
                                            true;
                                        detailController.unit.update((u) {
                                          u?.tenantCount = u.tenantCount! - 1;
                                          u?.updatedAt = DateTime.now();

                                          u?.tenantNames = u.tenantNames!
                                              .replaceAll(
                                                '${tenant.fullName},',
                                                '',
                                              )
                                              .replaceAll(
                                                ', ${tenant.fullName}',
                                                '',
                                              );
                                        });

                                        debugPrint(
                                          'Tenant removed successfully: ${detailController.unit.value.tenantNames}',
                                        );
                                        //getUnitContracts
                                        detailController.getUnitContracts(
                                          detailController.unit.value,
                                        );
                                        detailController
                                            .getTenantsOfCurrentUnit();

                                        // refresh the list of tenants
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
