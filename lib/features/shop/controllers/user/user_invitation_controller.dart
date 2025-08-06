import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/data/abstract/base_data_table_controller.dart';
import 'package:xm_frontend/data/models/object_model.dart';
import 'package:xm_frontend/data/repositories/object/object_repository.dart';
import 'package:xm_frontend/data/repositories/user/user_repository.dart';
import 'package:xm_frontend/features/personalization/controllers/user_controller.dart';
import 'package:xm_frontend/features/personalization/models/user_model.dart';
import 'package:xm_frontend/utils/helpers/helper_functions.dart';

import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../utils/popups/loaders.dart';

/// Controller for handling login functionality
class UserInvitationController extends TBaseController<UserModel> {
  static UserInvitationController get instance => Get.find();

  /// Whether the password should be hidden
  final hidePassword = true.obs;
  final hideConfirmPassword = true.obs;

  final selectedBuildingId = 0.obs;

  RxList<UserModel> allUsers = <UserModel>[].obs;
  RxList<UserModel> filteredUsers = <UserModel>[].obs;

  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);

  RxInt selectedStatusId = (-1).obs; // -1 means all statuses
  RxInt selectedObjectFilterId = 0.obs; // 0 = All

  /// Local storage instance for remembering ....
  final localStorage = GetStorage();

  /// Text editing controller for the firtsName field
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final phoneNumber = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  final searchController = TextEditingController();

  /// Form key for the register form
  final formKey = GlobalKey<FormState>();

  var userModel = UserModel.empty().obs; // Make it observable

  RxBool isDataUpdated = false.obs;

  final paginatedPage = 0.obs;

  var loading = false.obs;

  final isSendingBulk = false.obs;

  RxList<ObjectModel> objectsList = <ObjectModel>[].obs;

  final _userRepository = Get.put(UserRepository());
  final _objectRepository = Get.put(ObjectRepository());

  RxBool filtersApplied = false.obs; // Track if filters are applied

  final userController = Get.find<UserController>();

  /// Init Data
  // void init(AgentInvitationModel agentModel) {
  //   firstName.text = agentModel.agentFirstName;
  //   lastName.text = agentModel.agentLastName;
  //   email.text = agentModel.agentEmail;
  //   phoneNumber.text = agentModel.agentPhoneNumber;
  // }

  @override
  void onInit() {
    super.onInit();
    loadAllObjects();
    loadUsers();
  }

  void initFormFields() {
    firstName.text=userModel.value.firstName;
    lastName.text = userModel.value.lastName;
    email.text = userModel.value.email;
  }

  void loadAllObjects() async {
    try {
      final result = await _objectRepository.getAllObjects();

      final updatedUser = await userController.fetchUserDetails();

      final userObjectRestrictions = updatedUser.objectPermissionIds ?? [];

      // debugPrint('User object restrictions: $userObjectRestrictions');

      final filteredObjects =
          result
              .where(
                (object) => userObjectRestrictions.contains(
                  int.parse(object.id.toString()),
                ),
              )
              .toList();

      objectsList.assignAll(filteredObjects);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load objects: $e');
    } finally {
      loading.value = false;
    }
  }

  Future<void> loadUsers() async {
    loading.value = true;
    try {
      final users = await _userRepository.getAllCompanyObjectUsers();

      debugPrint('Loaded users: ${users.length}');

      final updatedUser = await userController.fetchUserDetails();

      final userObjectRestrictions = updatedUser.objectPermissionIds ?? [];

      debugPrint('User object restrictions: $userObjectRestrictions');

      final filteredUsersData =
          users
              .where(
                (user) => userObjectRestrictions.contains(
                  int.parse(user.objectId.toString()),
                ),
              )
              .toList();

      debugPrint('Filtered users: ${filteredUsersData.length}');


      filteredUsers.assignAll(allUsers);
    } catch (e) {
      TLoaders.errorSnackBar(
        title: "Error",
        message: "Failed to load users.",
      );
    } finally {
      loading.value = false;
    }
  }

  List<UserModel> getSelectedUsers() {
    return selectedRows
        .asMap()
        .entries
        .where((entry) => entry.value && entry.key < filteredItems.length)
        .map((entry) => filteredItems[entry.key])
        .toList();
  }

  Future<void> submitUser() async {
    if (!formKey.currentState!.validate()) return;

    loading.value = true;

    // Create a new tenant

    // get the user loged in
    final user = AuthenticationRepository.instance.currentUser;

    if (selectedBuildingId.value == 0) {
      TLoaders.errorSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_error'),
        message: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_no_building_id'),
      );
      return;
    }

    var statusCode = 0; // 0 means exists, 1 created new user , 2 failed

    statusCode = await UserRepository.instance.quickUserInsert(
      firstName.text,
      lastName.text,
      email.text,
      selectedObjectFilterId.value,
      int.parse(user!.id.toString()),
    );

    loading.value = false;

    if (statusCode == 1) {
      Get.back(result: true); //  Return `true` to indicate tenant was created

      TLoaders.successSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_info'),
        message: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_data_submitted'),
      );
    } else if (statusCode == 0) {
      TLoaders.errorSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_error'),
        message: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_data_exists'),
      );
    } else {
      TLoaders.errorSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_error'),
        message: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_data_failed_to_add'),
      );
    }
  }

  Future<void> submitUpdateUser() async {
    if (!formKey.currentState!.validate()) return;

    loading.value = true;

    final isUpdated = await UserRepository.instance.quickUserUpdate(
      firstName.text,
      lastName.text,
      userModel.value.objectId!,
      int.parse(userModel.value.id!),
    );

    loading.value = false;

    if (isUpdated) {
      // Update the user model with new values
      userModel.value.firstName = firstName.text;
      userModel.value.lastName = lastName.text;
      userModel.value.email = email.text;

      // Refresh the observable
      userModel.refresh();
      isDataUpdated.value = true;

      Get.back(result: true); //  Return `true`

      TLoaders.successSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_info'),
        message: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_data_updated'),
      );
    } else {
      TLoaders.errorSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_error'),
        message: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_data_failed'),
      );
    }
  }

  void applyFilters(
    int statusId,
    int objectId,
    DateTime? start,
    DateTime? end,
  ) {
    selectedStatusId.value = statusId;

    selectedObjectFilterId.value = objectId;
    startDate.value = start;
    endDate.value = end;

    filterItemsWithSearch(searchController.text);
  }

  void clearFilters() {
    selectedStatusId.value = -1;
    selectedObjectFilterId.value = 0;
    startDate.value = null;
    endDate.value = null;
    searchController.clear();
    filterItemsWithSearch('');
  }

  void clearStartDate() {
    startDate.value = null;
  }

  void clearEndDate() {
    endDate.value = null;
  }

  void resetFields() {
    firstName.clear();
    lastName.clear();
    email.clear();
    phoneNumber.clear();
    password.clear();
    confirmPassword.clear();
    selectedObjectFilterId.value = 0; // Reset selected object ID
  }

  Map<int, String> getTranslatedUserStatuses() {
    return {
      -1: AppLocalization.of(Get.context!).translate("general_msgs.msg_all"),
      1: THelperFunctions.getUserStatusText(1),
      2: THelperFunctions.getUserStatusText(2),
      3: THelperFunctions.getUserStatusText(3),
      4: THelperFunctions.getUserStatusText(4),
    };
  }

  void filterItemsWithSearch([String query = '']) {
    final results =
        allItems.where((item) {
          final matchesSearch = containsSearchQuery(item, query);

          final matchesStatus =
              selectedStatusId.value == -1 || // All
              item.statusId == selectedStatusId.value;

          final matchesObject =
              selectedObjectFilterId.value == 0 ||
              item.objectId == selectedObjectFilterId.value;

          final matchesStartDate =
              startDate.value == null ||
              item.createdAt!.isAfter(startDate.value!);

          final matchesEndDate =
              endDate.value == null || item.createdAt!.isBefore(endDate.value!);

          return matchesSearch &&
              matchesStatus &&
              matchesObject &&
              matchesStartDate &&
              matchesEndDate;
        }).toList();

    filteredItems.assignAll(results);
  }

  List<Map<String, VoidCallback>> getActiveFilters() {
    final List<Map<String, VoidCallback>> filters = [];

    if (selectedStatusId.value != -1) {
      filters.add({
        THelperFunctions.getUserStatusText(selectedStatusId.value): () {
          selectedStatusId.value = -1;
          applyFilters(
            selectedStatusId.value,
            selectedObjectFilterId.value,
            startDate.value,
            endDate.value,
          );
        },
      });
    }

    if (selectedObjectFilterId.value != 0) {
      final selectedObject = objectsList.firstWhereOrNull(
        (b) => int.parse(b.id!) == selectedObjectFilterId.value,
      );
      if (selectedObject != null) {
        filters.add({
          selectedObject.name.toString(): () {
            selectedObjectFilterId.value = 0;
            applyFilters(
              selectedStatusId.value,
              selectedObjectFilterId.value,
              startDate.value,
              endDate.value,
            );
          },
        });
      }
    }

    if (startDate.value != null) {
      filters.add({
        '${AppLocalization.of(Get.context!).translate("general_msgs.msg_from")} ${THelperFunctions.getFormattedDate(startDate.value!)}':
            () {
              startDate.value = null;
              applyFilters(
                selectedStatusId.value,
                selectedObjectFilterId.value,
                startDate.value,
                endDate.value,
              );
            },
      });
    }

    if (endDate.value != null) {
      filters.add({
        '${AppLocalization.of(Get.context!).translate("general_msgs.msg_until")} ${THelperFunctions.getFormattedDate(endDate.value!)}':
            () {
              endDate.value = null;
              applyFilters(
                selectedStatusId.value,
                selectedObjectFilterId.value,
                startDate.value,
                endDate.value,
              );
            },
      });
    }

    return filters;
  }

  /// Function to toggle password visibility
  void togglePasswordVisibility() {
    hidePassword.value = !hidePassword.value;
  }

  /// Function to toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    hideConfirmPassword.value = !hideConfirmPassword.value;
  }

  @override
  Future<List<UserModel>> fetchItems() async {
    //  return await _userRepository.getAllBuildingTenants();asdasd

    final result = await _userRepository.getAllCompanyObjectUsers();

    final updatedUser = await userController.fetchUserDetails();

    final userObjectRestrictions = updatedUser.objectPermissionIds ?? [];

    debugPrint('User object restrictions: $userObjectRestrictions');

    final filteredUsersData =
        result
            .where(
              (user) => userObjectRestrictions.contains(
                int.parse(user.objectId.toString()),
              ),
            )
            .toList();

    final filteredUsersDataActive =
        filteredUsersData
            .where((user) => user.contractStatus == 1)
            .toList();

    return filteredUsersDataActive;
  }

  Future<void> sendUserInvitation(UserModel user) async {
    try {
      // create a invitation record

      debugPrint('Sending Invitation for User: ${user.toJson()}');

      final invitationCode = await UserRepository.instance
          .createUserInvitationCode(
            user.email.trim(),
            int.parse(user.id!)
          );

      debugPrint('Invitation Code: $invitationCode');

      if (invitationCode.isNotEmpty) {
        // Send email invitation
        final fullName = '${user.firstName} ${user.lastName}';

        final greetings =
            '${AppLocalization.of(Get.context!).translate('general_msgs.msg_mail_dear')} $fullName,';
        final bodyText = AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_mail_body_text_tenant_invitation');
        final invitationCodeText = AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_mail_invitation_code_text');
        final availableOnText = AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_mail_available_on');
        final helpText = AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_mail_help_text');
        final supportText = AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_mail_support_text');
        final subject = AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_mail_subject_tenant_invitation_code');

        final subjectCombo =
            '${AuthenticationRepository.instance.currentUser?.companyName ?? ''} - $subject';

        debugPrint('Subject: $subjectCombo');

        final emailSent = await UserRepository.instance
            .sendUserInvitationCodeEmail(
              greetings,
              bodyText,
              invitationCodeText,
              invitationCode,
              availableOnText,
              helpText,
              supportText,
              subjectCombo,
              user.email.trim(),
            );  

        if (emailSent) {
          // update status id to 1 (invited)
          await UserRepository.instance.updateUserObjectStatus(
            int.parse(user.id!),
            1,
            user.objectId!,
          );

          TLoaders.successSnackBar(
            title: AppLocalization.of(
              Get.context!,
            ).translate('general_msgs.msg_info'),
            message: AppLocalization.of(
              Get.context!,
            ).translate('general_msgs.msg_new_invitation_code_sent'),
          );
        } else {
          TLoaders.errorSnackBar(
            title: AppLocalization.of(
              Get.context!,
            ).translate('general_msgs.msg_error'),
            message: AppLocalization.of(
              Get.context!,
            ).translate('general_msgs.msg_failed_to_send_invitation_code'),
          );
        }
      }
    } catch (e) {
      loading.value = false;
      TLoaders.errorSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_error'),
        message: e.toString(),
      );
    }
  }

  Future<void> sendUserInvitationBulk(List<UserModel> users) async {
    int sent = 0;
    int failed = 0;
    List<String> failedNames = [];
    loading.value = true;
    try {
      for (final user in users) {
        try {
          // create invitation record
          debugPrint('Sending Invitation for User: ${user.toJson()}');
          final invitationCode = await UserRepository.instance
              .createUserInviationCode(
                user.email.trim(),
                int.parse(user.id!) 
              );

          debugPrint('Invitation Code: $invitationCode');

          if (invitationCode.isNotEmpty) {
            // Send email invitation
            final fullName = '${user.firstName} ${user.lastName}';
            final greetings =
                '${AppLocalization.of(Get.context!).translate('general_msgs.msg_mail_dear')} $fullName,';
            final bodyText = AppLocalization.of(
              Get.context!,
            ).translate('general_msgs.msg_mail_body_text_tenant_invitation');
            final invitationCodeText = AppLocalization.of(
              Get.context!,
            ).translate('general_msgs.msg_mail_invitation_code_text');
            final availableOnText = AppLocalization.of(
              Get.context!,
            ).translate('general_msgs.msg_mail_available_on');
            final helpText = AppLocalization.of(
              Get.context!,
            ).translate('general_msgs.msg_mail_help_text');
            final supportText = AppLocalization.of(
              Get.context!,
            ).translate('general_msgs.msg_mail_support_text');
            final subject = AppLocalization.of(
              Get.context!,
            ).translate('general_msgs.msg_mail_subject_tenant_invitation_code');

            final subjectCombo =
                '${AuthenticationRepository.instance.currentUser?.companyName ?? ''} - $subject';

            debugPrint('Subject: $subjectCombo');

            final emailSent = await UserRepository.instance
                .sendUserInvitationCodeEmail(
                  greetings,
                  bodyText,
                  invitationCodeText,
                  invitationCode,
                  availableOnText,
                  helpText,
                  supportText,
                  subjectCombo,
                  user.email.trim(),
                );

            if (emailSent) {
              // update status id to 1 (invited)
              await UserRepository.instance.updateUserObjectStatus(
                int.parse(user.id!),
                1,
                user.objectId!,
              );
              sent++;
            } else {
              failed++;
              failedNames.add(fullName);
            }
          } else {
            failed++;
            failedNames.add('${user.firstName} ${user.lastName}');
          }
        } catch (e) {
          failed++;
          failedNames.add('${user.firstName} ${user.lastName}');
          // Optionally: log error for this user
        }
      }

      loading.value = false;
      // Show summary notification at the end
      if (sent > 0 && failed == 0) {
        TLoaders.successSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_info'),
          message: AppLocalization.of(Get.context!)
              .translate('general_msgs.msg_bulk_invitation_success')
              .replaceAll('{count}', sent.toString()),
        );
      } else if (sent > 0 && failed > 0) {
        TLoaders.errorSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_info'),
          message:
              "${sent} ${AppLocalization.of(Get.context!).translate('general_msgs.msg_sent_successfully')}, ${failed} ${AppLocalization.of(Get.context!).translate('general_msgs.msg_failed')}: ${failedNames.join(', ')}",
        );
      } else {
        TLoaders.errorSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_error'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_bulk_invitation_failed'),
        );
      }
    } catch (e) {
      loading.value = false;
      TLoaders.errorSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_error'),
        message: e.toString(),
      );
    }
  }

  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
      (UserModel b) => b.fullName.toString().toLowerCase(),
    );
  }

  void sortByObject(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
      (UserModel b) => b.objectName.toString().toLowerCase(),
    );
  }

  void sortByEmail(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
      (UserModel b) => b.email.toString().toLowerCase(),
    );
  }

  void sortByPhone(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
      (UserModel b) => b.phoneNumber.toString().toLowerCase(),
    );
  }

  void sortByUnit(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
      (UserModel b) => b.unitNumber.toString().toLowerCase(),
    );
  }

  void sortByContract(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
      (UserModel b) => b.contractReference.toString().toLowerCase(),
    );
  }

  void sortByStatus(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
      (UserModel b) => b.statusId.toString().toLowerCase(),
    );
  }

  void sortByCreatedAt(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
      (UserModel b) => b.updatedAt.toString().toLowerCase(),
    );
  }

  @override
  bool containsSearchQuery(UserModel item, String query) {
    return item.firstName.toLowerCase().contains(query.toLowerCase()) ||
        item.lastName.toLowerCase().contains(query.toLowerCase()) ||
        item.email.toLowerCase().contains(query.toLowerCase());
  }

  @override
  Future<bool> deleteItem(UserModel item) async {
    return await _userRepository.deleteUserById(
      int.parse(item.id!),
      item.objectId!,
    );
  }
}
