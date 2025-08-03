import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
//import 'package:xm_frontend/data/models/contract_model.dart';
import 'package:xm_frontend/features/personalization/models/user_model.dart';
import 'package:xm_frontend/features/shop/controllers/contract/contract_controller.dart';
import 'package:xm_frontend/features/shop/screens/user/dialogs/create_user.dart';
import 'package:xm_frontend/routes/routes.dart';
import 'package:xm_frontend/utils/constants/colors.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/validators/validation.dart';

class EditContractDialog extends StatelessWidget {
  const EditContractDialog({
    super.key,
    required this.contractId,
    this.isAddTenant = false,
    this.isShowFullDetailsBtn = true,
    this.isFromAssignContract = false,
  });

  final int contractId;
  final bool isAddTenant;
  final bool isShowFullDetailsBtn;
  final bool isFromAssignContract;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ContractController());

    return FutureBuilder<void>(
      future: controller.initializeContractData(contractId),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Dialog(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: SizedBox(
                width: 500,
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          );
        }

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: TRoundedContainer(
            width: 600,
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Form(
              key: controller.formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalization.of(
                          context,
                        ).translate('edit_contract_screen.lbl_update_contract'),
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  if (!isAddTenant) ...[
                    /// Contract Reference
                    TextFormField(
                      controller: controller.contractReferenceController,
                      decoration: InputDecoration(
                        labelText: AppLocalization.of(context).translate(
                          'unit_detail_screen.lbl_contract_reference',
                        ),
                        prefixIcon: Icon(Icons.description),
                      ),
                      validator:
                          (value) => TValidator.validateEmptyText(
                            AppLocalization.of(context).translate(
                              'unit_detail_screen.lbl_contract_reference',
                            ),
                            value,
                          ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    /// Start Date
                    TextFormField(
                      controller: controller.startDateController,
                      readOnly: true,
                      onTap:
                          () => controller.editPickStartDate(
                            context,
                            controller.contractModel.value.startDate ??
                                DateTime.now(),
                          ),
                      decoration: InputDecoration(
                        labelText: AppLocalization.of(
                          context,
                        ).translate('unit_detail_screen.lbl_start_date'),
                        prefixIcon: Icon(Icons.date_range),
                      ),
                      validator:
                          (value) => TValidator.validateEmptyText(
                            AppLocalization.of(
                              context,
                            ).translate('unit_detail_screen.lbl_start_date'),
                            value,
                          ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    /// End Date
                    if (!isFromAssignContract) ...[
                      TextFormField(
                        controller: controller.endDateController,
                        readOnly: true,
                        onTap:
                            () => controller.editPickEndDate(
                              context,
                              controller.contractModel.value.endDate ??
                                  DateTime.now(),
                            ),
                        decoration: InputDecoration(
                          labelText: AppLocalization.of(
                            context,
                          ).translate('edit_contract_screen.lbl_end_date'),
                          prefixIcon: const Icon(Icons.date_range),
                          suffixIcon:
                              controller.endDateController.text.isNotEmpty
                                  ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      controller.endDateController.clear();
                                      controller.contractModel.value.endDate =
                                          null;
                                    },
                                  )
                                  : null,
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields),

                      /// Status Dropdown
                      DropdownButtonFormField<int>(
                        value: controller.selectedStatus.value,
                        onChanged:
                            (value) => controller.selectedStatus.value = value!,
                        items: [
                          DropdownMenuItem(
                            value: 3,
                            child: Text(
                              AppLocalization.of(
                                context,
                              ).translate('general_msgs.msg_pending'),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 1,
                            child: Text(
                              AppLocalization.of(
                                context,
                              ).translate('general_msgs.msg_active'),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 2,
                            child: Text(
                              AppLocalization.of(
                                context,
                              ).translate('general_msgs.msg_terminated'),
                            ),
                          ),
                        ],
                        decoration: InputDecoration(
                          labelText: AppLocalization.of(
                            context,
                          ).translate('edit_contract_screen.lbl_status'),
                          prefixIcon: Icon(Iconsax.status),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return AppLocalization.of(
                              context,
                            ).translate('edit_contract_screen.lbl_status');
                          }
                          return null;
                        },
                      ),
                    ],
                  ],

                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  /// Tenants Multi-select
                  Obx(() {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        primaryColor: TColors.primary,
                        checkboxTheme: CheckboxThemeData(
                          fillColor: MaterialStateProperty.all(TColors.primary),
                        ),
                      ),
                      child: MultiSelectDialogField<UserModel>(
                        title: Text(
                          AppLocalization.of(context).translate(
                            'edit_permission_screen.lbl_select_users',
                          ),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        buttonText: Text(
                          AppLocalization.of(context).translate(
                            'edit_permission_screen.lbl_select_users',
                          ),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),

                        searchable: true,
                        listType: MultiSelectListType.LIST,
                        selectedColor: TColors.primary,
                        itemsTextStyle: Theme.of(context).textTheme.bodyLarge,
                        dialogHeight: 500,
                        dialogWidth: 600, // Optional for desktop
                        items:
                            controller.users
                                .map(
                                  (t) => MultiSelectItem<UserModel>(
                                    t,
                                    '${t.displayName}\n${t.email}',
                                  ),
                                )
                                .toList(),
                        initialValue: controller.selectedUsers,
                        onConfirm: (values) {
                          controller.selectedUsers.value = values;
                        },
                        chipDisplay: MultiSelectChipDisplay(
                          chipColor: TColors.primary.withOpacity(0.1),
                          textStyle: Theme.of(context).textTheme.bodyMedium,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          items:
                              controller.selectedUsers
                                  .map(
                                    (t) => MultiSelectItem<UserModel>(
                                      t,
                                      t.displayName,
                                    ),
                                  )
                                  .toList(),
                        ),
                        // validator: (values) {
                        //   if (values == null || values.isEmpty) {
                        //     return AppLocalization.of(context).translate(
                        //       'edit_contract_screen.error_msg_please_select_at_least_one_tenant',
                        //     );
                        //   }
                        //   return null;
                        // },
                      ),
                    );
                  }),
                  const SizedBox(height: TSizes.spaceBtwInputFields * 2),

                  /// Actions
                  Row(
                    children: [
                      Expanded(
                        child:
                        /// Submit Button
                        Obx(() {
                          return controller.loading.value
                              ? const Center(child: CircularProgressIndicator())
                              : SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    controller.submitContractUpdate(
                                      controller.contractModel.value,
                                    );
                                  },
                                  child: Text(
                                    AppLocalization.of(
                                      context,
                                    ).translate('general_msgs.msg_update'),
                                  ),
                                ),
                              );
                        }),
                      ),

                      const SizedBox(width: TSizes.spaceBtwItems),
                      if (isShowFullDetailsBtn)
                        Expanded(
                          child: TextButton.icon(
                            onPressed: () {
                              Get.back(); // Close the dialog first

                              Get.toNamed(
                                Routes.contractDetails,
                                arguments: controller.contractModel.value,
                              )?.then((result) async {
                                if (result == true) {
                                  controller.initializeContractData(contractId);
                                }
                              });
                            },
                            icon: const Icon(Icons.remove_red_eye),
                            label: Text(
                              AppLocalization.of(
                                context,
                              ).translate('general_msgs.msg_view_full_details'),
                            ),
                          ),
                        ),
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () async {
                            final result = await showDialog<bool>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return CreateUserDialog(
                                  displayObjects: false,
                                  objectId:
                                      controller.contractModel.value.objectId,
                                );
                              },
                            );

                            // If the tenant was created (e.g., result == true), reload the list
                            if (result == true) {
                              controller.initializeContractData(
                                contractId,
                              ); // or whatever your method is
                            }
                          },

                          icon: const Icon(Icons.person_add),
                          label: Text(
                            AppLocalization.of(
                              context,
                            ).translate('users_screen.lbl_create_new_user'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
