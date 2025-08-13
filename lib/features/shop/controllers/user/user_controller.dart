import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/data/abstract/base_data_table_controller.dart';
import 'package:xm_frontend/data/models/object_model.dart';
import 'package:xm_frontend/data/repositories/object/object_repository.dart';
import 'package:xm_frontend/data/repositories/user/user_repository.dart';
import 'package:xm_frontend/features/personalization/controllers/settings_controller.dart';
// Removed ambiguous import of personalization UserController
import 'package:xm_frontend/features/personalization/models/user_model.dart';
import 'package:xm_frontend/features/shop/controllers/object/object_unit_detail_controller.dart';
import 'package:xm_frontend/features/shop/controllers/contract/permission_controller.dart';
import 'package:xm_frontend/utils/helpers/helper_functions.dart';

import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../utils/popups/loaders.dart';

/// Controller for handling login functionality
class UserController extends TBaseController<UserModel> {
  static UserController get instance => Get.find();

  /// Whether the password should be hidden
  final hidePassword = true.obs;
  final hideConfirmPassword = true.obs;

  final selectedObjectId = 0.obs;

  RxList<UserModel> allUsers = <UserModel>[].obs;
  RxList<UserModel> filteredUsers = <UserModel>[].obs;

  RxList<UserModel> allUsersAppInvitation = <UserModel>[].obs;
  RxList<UserModel> filteredUsersAppInvitation = <UserModel>[].obs;

  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);

  Rx<DateTime?> startInvitationDate = Rx<DateTime?>(null);
  Rx<DateTime?> endInvitationDate = Rx<DateTime?>(null);

  RxInt selectedStatusId = (-1).obs; // -1 means all statuses
  RxInt selectedObjectFilterId = 0.obs; // 0 = All

  RxInt selectedInvitationStatusId = (-1).obs; // -1 means all statuses
  RxInt selectedInvitationObjectFilterId = 0.obs; // 0 = All

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
  final searchInvitationController = TextEditingController();

  /// Form key for the register form
  final formKey = GlobalKey<FormState>();

  var userModel = UserModel.empty().obs; // Make it observable

  RxBool isDataUpdated = false.obs;

  final paginatedPage = 0.obs;

  var loading = false.obs;

  RxList<ObjectModel> objectsList = <ObjectModel>[].obs;

  final _userRepository = Get.put(UserRepository());
  final _objectRepository = Get.put(ObjectRepository());

  RxBool filtersApplied = false.obs; // Track if filters are applied
  RxBool invitationFiltersApplied =
      false.obs; // Track if invitation filters are applied

  final userController = UserController.instance; 

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
    firstName.text = userModel.value.firstName;
    lastName.text = userModel.value.lastName;
    email.text = userModel.value.email;
  }

  void loadAllObjects() async {
    try {
      final result = await _objectRepository.getAllObjects();

      final updatedUser = userModel.value;

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

      final updatedUser = userModel.value;

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

      allUsers.assignAll(filteredUsersData);
      filteredUsers.assignAll(filteredUsersData);


      filteredUsersAppInvitation.assignAll(allUsers);
    } catch (e) {
      TLoaders.errorSnackBar(
        title: "Error",
        message: "Failed to load tenants.",
      );
    } finally {
      loading.value = false;
    }
  }

  Future<void> submitUser() async {
    if (!formKey.currentState!.validate()) return;

    loading.value = true;

    // Create a new tenant

    // get the user loged in
    final user = AuthenticationRepository.instance.currentUser;

    if (selectedObjectId.value == 0) {
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

    var statusCode = 0; // 0 means exists, 1 created new tenant , 2 failed

    statusCode = await UserRepository.instance.quickUserInsert(
      firstName.text,
      lastName.text,
      email.text,
      phoneNumber.text,
      2,
      1
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

  /// for Invitation
  void applyInvitationFilters(
    int statusId,
    int objectId,
    DateTime? start,
    DateTime? end,
  ) {
    selectedInvitationStatusId.value = statusId;

    selectedInvitationObjectFilterId.value = objectId;
    startInvitationDate.value = start;
    endInvitationDate.value = end;

    filterItemsInvitationWithSearch(searchInvitationController.text);
  }

  void clearInvitationFilters() {
    selectedInvitationStatusId.value = -1;
    selectedInvitationObjectFilterId.value = 0;
    startInvitationDate.value = null;
    endInvitationDate.value = null;
    searchInvitationController.clear();
    filterItemsInvitationWithSearch('');
  }

  void clearInvitationStartDate() {
    startInvitationDate.value = null;
  }

  void clearInvitationEndDate() {
    endInvitationDate.value = null;
  }

  void resetFields() {
    firstName.clear();
    lastName.clear();
    email.clear();
    phoneNumber.clear();
    password.clear();
    confirmPassword.clear();
    selectedObjectId.value = 0; // Reset selected object ID
  }

  Map<int, String> getTranslatedContractStatuses() {
    return {
      -1: AppLocalization.of(Get.context!).translate("general_msgs.msg_all"),
      1: THelperFunctions.getUnitContractStatusText(1),
      2: THelperFunctions.getUnitContractStatusText(2),
      3: THelperFunctions.getUnitContractStatusText(3),
      4: THelperFunctions.getUnitContractStatusText(4),
    };
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
              (selectedStatusId.value == 4 &&
                  (item.contractStatus == null ||
                      item.contractStatus == 0)) || // Unassigned
              (item.contractStatus != null &&
                  item.contractStatus == selectedStatusId.value);

          final matchesObject =
              selectedObjectFilterId.value == 0 ||
              item.objectId == selectedObjectFilterId.value;

          final matchesStartDate =
              startDate.value == null ||
              item.createdAt!.isAfter(startDate.value!);

          final matchesEndDate =
              endDate.value == null || item.createdAt!.isBefore(endDate.value!);

          // if (selectedStatusId.value == 4) {
          //   debugPrint(
          //     'Evaluating ${item.fullName} → contractStatus=${item.contractStatus}',
          //   );
          // }

          return matchesSearch &&
              matchesStatus &&
              matchesObject &&
              matchesStartDate &&
              matchesEndDate;
        }).toList();

    filteredItems.assignAll(results);

  selectedRows.value = List<bool>.filled(filteredItems.length, false); // <-- Add 
  }

  void filterItemsInvitationWithSearch([String query = '']) {
    final results =
        allUsersAppInvitation.where((item) {
          final matchesSearch = containsSearchQuery(item, query);

          final matchesStatus =
              selectedInvitationStatusId.value == -1 || // All
              (selectedInvitationStatusId.value == 4 &&
                  (item.statusId == null ||
                      item.statusId == 0)) || // Unassigned
              (item.statusId != null &&
                  item.statusId == selectedInvitationStatusId.value);

          final matchesObject =
              selectedInvitationObjectFilterId.value == 0 ||
              item.objectId == selectedInvitationObjectFilterId.value;

          final matchesStartDate =
              startInvitationDate.value == null ||
              item.updatedAt!.isAfter(startInvitationDate.value!);

          final matchesEndDate =
              endInvitationDate.value == null ||
              item.updatedAt!.isBefore(endInvitationDate.value!);

          return matchesSearch &&
              matchesStatus &&
              matchesObject &&
              matchesStartDate &&
              matchesEndDate;
        }).toList();

    filteredUsersAppInvitation.assignAll(results);
  }

  List<Map<String, VoidCallback>> getActiveFilters() {
    final List<Map<String, VoidCallback>> filters = [];

    if (selectedStatusId.value != -1) {
      filters.add({
        THelperFunctions.getUnitContractStatusText(selectedStatusId.value): () {
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
        (b) => b.id! == selectedObjectFilterId.value,
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

  List<Map<String, VoidCallback>> getActiveInvitationFilters() {
    final List<Map<String, VoidCallback>> filters = [];

    if (selectedInvitationStatusId.value != -1) {
      filters.add({
        THelperFunctions.getUserStatusText(
          selectedInvitationStatusId.value,
        ): () {
          selectedInvitationStatusId.value = -1;
          applyFilters(
            selectedInvitationStatusId.value,
            selectedInvitationObjectFilterId.value,
            startInvitationDate.value,
            endInvitationDate.value,
          );
        },
      });
    }

    if (selectedInvitationObjectFilterId.value != 0) {
      final selectedObject = objectsList.firstWhereOrNull(
        (b) => b.id! == selectedInvitationObjectFilterId.value,
      );
      if (selectedObject != null) {
        filters.add({
          selectedObject.name.toString(): () {
            selectedInvitationObjectFilterId.value = 0;
            applyFilters(
              selectedInvitationStatusId.value,
              selectedInvitationObjectFilterId.value,
              startInvitationDate.value,
              endInvitationDate.value,
            );
          },
        });
      }
    }

    if (startInvitationDate.value != null) {
      filters.add({
        '${AppLocalization.of(Get.context!).translate("general_msgs.msg_from")} ${THelperFunctions.getFormattedDate(startInvitationDate.value!)}':
            () {
              startInvitationDate.value = null;
              applyFilters(
                selectedInvitationStatusId.value,
                selectedInvitationObjectFilterId.value,
                startInvitationDate.value,
                endInvitationDate.value,
              );
            },
      });
    }

    if (endInvitationDate.value != null) {
      filters.add({
        '${AppLocalization.of(Get.context!).translate("general_msgs.msg_until")} ${THelperFunctions.getFormattedDate(endInvitationDate.value!)}':
            () {
              endInvitationDate.value = null;
              applyFilters(
                selectedInvitationStatusId.value,
                selectedInvitationObjectFilterId.value,
                startInvitationDate.value,
                endInvitationDate.value,
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

    final updatedUser = userModel.value;

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

    return filteredUsersData;
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
      (UserModel b) => b.contractStatus.toString().toLowerCase(),
    );
  }

  void sortByCreatedAt(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
      (UserModel b) => b.createdAt.toString().toLowerCase(),
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
      int.parse(item.id!)
    );
  }
}
