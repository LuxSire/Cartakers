import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/data/models/user_role_model.dart';
import 'package:xm_frontend/features/personalization/models/user_model.dart';
import 'package:xm_frontend/features/shop/controllers/contract/permission_controller.dart';
import 'package:xm_frontend/features/personalization/controllers/user_controller.dart';
//import 'package:xm_frontend/features/personalization/controllers/object_controller.dart';
import 'package:xm_frontend/features/shop/controllers/object/object_controller.dart';
import 'package:xm_frontend/features/shop/screens/user/dialogs/create_user.dart';
import 'package:xm_frontend/utils/constants/colors.dart';
import 'package:xm_frontend/utils/popups/loaders.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/validators/validation.dart';

class CreateContractDialog extends StatelessWidget {
  const CreateContractDialog({
    super.key,
    required this.displayUnits,
    this.unitId,
    required this.objectId,
  });

  final bool? displayUnits;
  // for when create a contract from assign screen
  final int? unitId;
  final int objectId;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PermissionController());
   if (!Get.isRegistered<ObjectController>()) {
    Get.put(ObjectController(), permanent: true);
  }
  final  o_controller = Get.find<ObjectController>();
   
   
   if (!Get.isRegistered<UserController>()) {
    Get.put(UserController(), permanent: true);
  }
  final  u_controller = Get.find<UserController>();

    controller.contractReferenceController.clear();
    controller.startDateController.clear();
    controller.selectedUsers.value = [];
    controller.users.value = [];
    controller.selectedUnitId.value = 0;
    controller.selectedObjectId.value = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadAllObjects();
    });

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: TRoundedContainer(
        width: 500,
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Form(
          key: controller.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header with close icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalization.of(
                      context,
                    ).translate('create_contract_screen.lbl_create_new_permission'),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Contract Reference
              TextFormField(
                controller: controller.contractReferenceController,
                decoration: InputDecoration(
                  labelText: AppLocalization.of(
                    context,
                  ).translate('unit_detail_screen.lbl_contract_reference'),
                  prefixIcon: Icon(Icons.description),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              
              
                Obx(() {
                  return DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButtonFormField<int>(
                        isExpanded: true,
                        value:
                            controller.selectedObjectId.value != 0
                                ? controller.selectedObjectId.value
                                : null,
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectedObjectId.value = value;
                            o_controller.loadAllObjects();
                            u_controller.loadUsers(); // Load users for the selected object
                            
                          }
                        },
                        validator: (value) {
                          if (value == null || value == 0) {
                            return AppLocalization.of(context).translate(
                              'contract_screen.msg_object_required',
                            );
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: AppLocalization.of(
                            context,
                          ).translate('create_contract_screen.lbl_select_object'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                        ),
                        items: [
                          DropdownMenuItem<int>(
                            value: 0,
                            child: Text(
                              AppLocalization.of(context).translate(
                                "create_contract_screen.lbl_select_object",
                              ),
                            ),
                          ),
                          ...o_controller.allObjects.map(
                            (object) => DropdownMenuItem<int>(
                              value: object.id!,
                              child: Text(object.name!),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                const SizedBox(height: TSizes.spaceBtwInputFields),

              /// Single-select User (Dropdown)
              Obx(() {
                // Set user list to match object list using UserController
                final userList = u_controller.allUsers;
                return DropdownButtonFormField<int>(
                  isExpanded: true,
                  value: controller.selectedUserId.value != 0
                      ? controller.selectedUserId.value
                      : null,
                  onChanged: (user) {
                    if (user != null) {
                      controller.selectedUserId.value = user;
                    }
                  },
                  validator: (user) {
                    if (user == null) {
                      return AppLocalization.of(context).translate('create_contract_screen.lbl_select_users');
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: AppLocalization.of(context).translate('create_contract_screen.lbl_select_users'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                  ),
                  items: userList.map((user) {
                    return DropdownMenuItem<int>(
                      value: int.tryParse(user.id!),
                      child: Text('${user.displayName}'),
                    );
                  }).toList(),
                );
              }),

              const SizedBox(height: TSizes.spaceBtwInputFields * 2),

              Obx(() {
                // Set role list
                final roleList = u_controller.userRolesList;
                  // Find the selected UserRoleModel by id
                final selectedRole = roleList.firstWhereOrNull(
                (role) => role.id == u_controller.selectedRoleId.value,
                  );
                return DropdownButtonFormField(
                  isExpanded: true,
                  value: selectedRole,
                  onChanged: (role) {
                    if (role != null) {
                      u_controller.selectedRoleId.value = role.id;
                    }
                  },
                  validator: (role) {
                    if (role == null) {
                      return AppLocalization.of(context).translate('create_contract_screen.lbl_select_role');
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: AppLocalization.of(context).translate('create_contract_screen.lbl_select_role'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                  ),
                  items: roleList.map((role) {
                    return DropdownMenuItem<UserRoleModel>(
                      value: role,
                      child: Text(role.nameTranslated ?? role.name),
                    );
                  }).toList(),
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
                                  // Validate form
                                  if (controller.formKey.currentState?.validate() != true) return;

                                  // Only use selectedObjectId if it is not 0
                                  if (controller.selectedObjectId.value != 0 && controller.selectedUserId.value != 0) {
                                    int selectedUserId = controller.selectedUserId.value;
                                    int selectedObjectId = controller.selectedObjectId.value;
                                    int selectedRoleId= u_controller.selectedRoleId.value;
                                    debugPrint(wrapWidth: 80, 'Creating permission with User ID: $selectedUserId, Object ID: $selectedObjectId, Role ID: $selectedRoleId');
                                    controller.createPermission(
                                      selectedUserId,
                                      selectedObjectId,
                                      selectedRoleId,
                                    ).then((success) {
                                      debugPrint(wrapWidth: 80, 'Permission creation success: $success');
                                      if (success == true) {
                                        Get.back(result: true); // Close dialog and return true
                                      }
                                    });

                                  } else {
                                    TLoaders.errorSnackBar(
                                      title: AppLocalization.of(context).translate('general_msgs.msg_error'),
                                      message: AppLocalization.of(context).translate('contract_screen.lbl_please_select_a_object'),
                                    );
                                  }
                                },
                                child: Text(
                                  AppLocalization.of(
                                    context,
                                  ).translate('general_msgs.msg_add'),
                                ),
                              ),
                            );
                    }),
                  ),

                  const SizedBox(width: TSizes.spaceBtwItems),

                  Expanded(
                    child: TextButton.icon(
                      onPressed: () async {
                        bool useSelectedObject = false;

                        if (displayUnits == true) {
                          useSelectedObject = true;
                          if (controller.selectedObjectId.value == 0) {
                            TLoaders.errorSnackBar(
                              title: AppLocalization.of(
                                Get.context!,
                              ).translate('general_msgs.msg_error'),
                              message: AppLocalization.of(
                                Get.context!,
                              ).translate(
                                'contract_screen.lbl_please_select_a_object',
                              ),
                            );

                            return;
                          }
                        }

                        final result = await showDialog<bool>
                        (
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return CreateUserDialog(
                              displayObjects: false,
                              objectId:
                                  useSelectedObject
                                      ? controller.selectedObjectId.value
                                      : objectId,
                            );
                          },
                        );

                        // If the tenant was created (e.g., result == true), reload the list

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
  }
}
  