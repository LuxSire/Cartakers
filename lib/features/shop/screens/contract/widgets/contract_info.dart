import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/data/models/contract_model.dart';
import 'package:xm_frontend/features/shop/controllers/contract/contract_controller.dart';
import 'package:xm_frontend/features/shop/screens/contract/dialogs/edit_contract.dart';
import 'package:xm_frontend/features/shop/screens/user/dialogs/create_user.dart';

import 'package:xm_frontend/utils/constants/colors.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/device/device_utility.dart';
import '../../../../../../utils/helpers/helper_functions.dart';

class ContractInfo extends StatelessWidget {
  const ContractInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ContractController>();

    return Obx(() {
      final contract = controller.contractModel.value;

      return TRoundedContainer(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // mainAxisSize: MainAxisSize.max,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  AppLocalization.of(
                    context,
                  ).translate('contract_screen.lbl_contract_information'),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: TSizes.defaultSpace),
                    TextButton.icon(
                      onPressed: () async {
                        final updatedContract = await showDialog<ContractModel>(
                          context: Get.context!,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return EditContractDialog(
                              contractId: int.parse(contract.id!),
                              isShowFullDetailsBtn: false,
                            );
                          },
                        );

                        if (updatedContract != null) {
                          controller.contractModel.value.contractCode =
                              updatedContract.contractCode;
                          controller.contractModel.value.startDate =
                              updatedContract.startDate;
                          controller.contractModel.value.endDate =
                              updatedContract.endDate;
                          controller.contractModel.value.statusId =
                              updatedContract.statusId;
                          controller.contractModel.value.userCount =
                              updatedContract.userCount;
                          controller.contractModel.value.userNames =
                              updatedContract.userNames;
                          controller.contractModel.value.users =
                              updatedContract.users;

                          controller.contractModel.refresh();
                          controller.isDataUpdated.value = true;
                          controller.loadingUsers.value = true;

                          controller.loadUsers();
                        }
                      },

                      icon: const Icon(Icons.edit, color: TColors.alterColor),
                      label: Text(
                        style: TextStyle(color: TColors.alterColor),
                        AppLocalization.of(
                          context,
                        ).translate('general_msgs.msg_update'),
                      ),
                    ),
                  ],
                ),
              ],
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
                        ).translate('contract_screen.lbl_start_date'),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: TColors.black.withOpacity(0.5),
                        ),
                      ),
                      Text(
                        contract.formattedStartDate,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                if (controller.contractModel.value.statusId == 2) // terminated
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalization.of(
                            context,
                          ).translate('contract_screen.lbl_end_date'),
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(color: TColors.black.withOpacity(0.5)),
                        ),
                        Text(
                          contract.formattedEndDate,
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
                        ).translate('contract_screen.lbl_unit'),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: TColors.black.withOpacity(0.5),
                        ),
                      ),
                      Text(
                        contract.unitNumber,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),

                // if (controller.contractModel.value.tenantNames
                //     .toString()
                //     .isNotEmpty)
                //   Expanded(
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text(
                //           AppLocalization.of(
                //             context,
                //           ).translate('contract_screen.lbl_tenants'),
                //           style: Theme.of(context).textTheme.bodyLarge!
                //               .copyWith(color: TColors.black.withOpacity(0.5)),
                //         ),
                //         SizedBox(
                //           width: 200,
                //           child: Text(
                //             contract.tenantNames.toString(),
                //             style: Theme.of(context).textTheme.bodyLarge,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
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
                        contract.contractCode?.isEmpty == true
                            ? '-'
                            : contract.contractCode ?? '-',
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
                        ).translate('contract_screen.lbl_status'),
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
                        backgroundColor:
                            THelperFunctions.getUnitContractStatusColor(
                              contract.statusId ?? 0,
                            ).withOpacity(0.1),
                        child: Text(
                          THelperFunctions.getUnitContractStatusText(
                            contract.statusId ?? 0,
                          ),
                          style: TextStyle(
                            color: THelperFunctions.getUnitContractStatusColor(
                              contract.statusId ?? 0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // const SizedBox(height: TSizes.spaceBtwSections),
            // Divider(color: TColors.black.withOpacity(0.1), thickness: 1),

            // // Contract Details Tabs
            // DefaultTabController(
            //   length: 5, // Number of tabs
            //   child: Column(
            //     children: [
            //       TabBar(
            //         tabs: [
            //           Tab(text: 'Tenants', icon: Icon(Iconsax.profile_2user)),
            //           Tab(text: 'Documents'),
            //           Tab(text: 'Booking History'),
            //           Tab(text: 'Request History'),
            //           Tab(text: 'Notes/Logs'),
            //         ],
            //       ),
            //       const SizedBox(height: TSizes.defaultSpace),
            //       const SizedBox(
            //         height: 400,
            //         child: TabBarView(
            //           children: [
            //             // Tenants Tab
            //             ContractDetailsTab(tabType: 'Tenants'),
            //             // Documents Tab
            //             ContractDetailsTab(tabType: 'Documents'),
            //             // Booking History Tab
            //             ContractDetailsTab(tabType: 'Booking History'),
            //             // Request History Tab
            //             ContractDetailsTab(tabType: 'Request History'),
            //             // Notes/Logs Tab
            //             ContractDetailsTab(tabType: 'Notes/Logs'),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            //     ContractDetailsPage(),
          ],
        ),
      );
    });
  }
}
