import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/common/widgets/containers/rounded_container.dart';
import 'package:xm_frontend/common/widgets/loaders/animation_loader.dart';
import 'package:xm_frontend/data/models/contract_model.dart';
import 'package:xm_frontend/features/shop/controllers/contract/contract_controller.dart';
import 'package:xm_frontend/features/shop/screens/contract/dialogs/create_contract.dart';
import 'package:xm_frontend/features/shop/screens/contract/dialogs/edit_contract.dart';
import 'package:xm_frontend/utils/constants/colors.dart';
import 'package:xm_frontend/utils/constants/image_strings.dart';
import 'package:xm_frontend/utils/constants/sizes.dart';
import 'package:xm_frontend/utils/popups/loaders.dart';

class AssignContractDialog extends StatelessWidget {
  final int buildingId;
  final String unitNumer;
  final int unitId;
  final String buildingName;
  const AssignContractDialog({
    super.key,
    required this.buildingId,
    required this.unitNumer,
    required this.unitId,
    required this.buildingName,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ContractController());

    //   WidgetsBinding.instance.addPostFrameCallback((_) {

    // });

    controller.fetchItems().then((contracts) {
      final pendingContracts =
          contracts
              .where((c) => c.statusId == 3 && c.unitId == unitId)
              .toList();
      controller.filteredItems.assignAll(pendingContracts);
    });

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: TRoundedContainer(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        width: 700,
        child: Obx(() {
          final items = controller.filteredItems;

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${AppLocalization.of(context).translate('dashboard_screen.lbl_assign_contract')} - $unitNumer ($buildingName) ',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              if (items.isEmpty)
                // const Padding(
                //   padding: EdgeInsets.symmetric(vertical: 24),
                //   child: Center(child: Text("No pending contracts found")),
                // )
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
                    child: TAnimationLoaderWidget(
                      height: 250,
                      text: AppLocalization.of(context).translate(
                        'dashboard_screen.lbl_no_pending_contracts_found',
                      ),
                      animation: TImages.noDataIllustration,
                    ),
                  ),
                )
              else
                SizedBox(
                  height: 420,
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (_, index) {
                      final contract = items[index];

                      return Card(
                        color: TColors.softGrey,
                        elevation: 1,
                        margin: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 4,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Contract Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      contract.contractCode ?? '-',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium!.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: TColors.txt333333,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    if (contract.startDate != null)
                                      Text(
                                        '${AppLocalization.of(context).translate('general_msgs.msg_start_date')}: ${DateFormat('dd.MM.yyyy').format(contract.startDate!)}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(color: TColors.txt666666),
                                      ),
                                    const SizedBox(height: 4),
                                    if ((contract.tenantNames ?? '').isNotEmpty)
                                      Text(
                                        '${AppLocalization.of(context).translate('tenants_screen.lbl_tenants')}: ${contract.tenantNames}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(color: TColors.txt666666),
                                      ),
                                  ],
                                ),
                              ),

                              /// Assign Button
                              TextButton.icon(
                                onPressed: () async {
                                  final updatedContract =
                                      await showDialog<ContractModel>(
                                        context: Get.context!,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return EditContractDialog(
                                            contractId: int.parse(contract.id!),
                                            isShowFullDetailsBtn: false,
                                            isAddTenant: false,
                                            isFromAssignContract: true,
                                          );
                                        },
                                      );

                                  if (updatedContract != null) {
                                    controller.fetchItems().then((contracts) {
                                      final pendingContracts =
                                          contracts
                                              .where(
                                                (c) =>
                                                    c.statusId == 3 &&
                                                    c.unitId == unitId,
                                              )
                                              .toList();
                                      controller.filteredItems.assignAll(
                                        pendingContracts,
                                      );
                                    });
                                  }
                                },

                                icon: const Icon(
                                  Iconsax.edit,
                                  color: TColors.alterColor,
                                ),
                                label: Text(
                                  style: TextStyle(color: TColors.alterColor),
                                  AppLocalization.of(context).translate(
                                    'edit_contract_screen.lbl_update_contract',
                                  ),
                                ),
                              ),

                              TextButton.icon(
                                onPressed: () async {
                                  // first check if contract has tenants
                                  if (contract.tenantNames == null ||
                                      contract.tenantNames!.isEmpty) {
                                    TLoaders.errorSnackBar(
                                      title: AppLocalization.of(
                                        Get.context!,
                                      ).translate('general_msgs.msg_error'),
                                      message: AppLocalization.of(
                                        Get.context!,
                                      ).translate(
                                        'dashboard_screen.error_contract_must_have_at_least_one_tenant',
                                      ),
                                    );
                                    return;
                                  }

                                  // Assign contract to unit
                                  final controllerContract = Get.put(
                                    ContractController(),
                                  );

                                  await controllerContract
                                      .initializeContractData(
                                        int.parse(contract.id!),
                                      );

                                  debugPrint(
                                    'Assigning contract ${controllerContract.contractModel.value.contractCode} to building $buildingId and unit $unitNumer',
                                  );

                                  // update the status

                                  controllerContract
                                      .contractModel
                                      .value
                                      .statusId = 1;

                                  controllerContract
                                      .contractModel
                                      .value
                                      .endDate = null;

                                  await controllerContract.assignContract(
                                    controllerContract.contractModel.value,
                                  );
                                },
                                icon: const Icon(
                                  Iconsax.tick_circle,
                                  color: TColors.alterColor,
                                ),
                                label: Text(
                                  AppLocalization.of(
                                    context,
                                  ).translate('general_msgs.msg_assign'),
                                  style: const TextStyle(
                                    color: TColors.alterColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

              const SizedBox(height: TSizes.spaceBtwItems),
              Center(
                child: SizedBox(
                  width:
                      AppLocalization.of(context)
                          .translate(
                            'create_contract_screen.lbl_create_new_contract',
                          )
                          .length *
                      10.0,
                  child: ElevatedButton(
                    onPressed: () async {
                      debugPrint(
                        'Creating new contract for unitId $unitId and unit $unitNumer',
                      );

                      final newContract = await showDialog<bool>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return CreateContractDialog(
                            displayUniits: false,
                            unitId: unitId,
                            buildingId: buildingId,
                          );
                        },
                      );

                      if (newContract == true) {
                        controller.fetchItems().then((contracts) {
                          final pendingContracts =
                              contracts
                                  .where(
                                    (c) =>
                                        c.statusId == 3 && c.unitId == unitId,
                                  )
                                  .toList();
                          controller.filteredItems.assignAll(pendingContracts);
                        });
                      }
                    },
                    child: Text(
                      AppLocalization.of(context).translate(
                        'create_contract_screen.lbl_create_new_contract',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
