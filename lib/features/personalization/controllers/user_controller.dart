import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/data/abstract/base_data_table_controller.dart';
import 'package:xm_frontend/data/api/translation_api.dart';
import 'package:xm_frontend/data/models/object_model.dart';
import 'package:xm_frontend/data/models/user_role_model.dart';
import 'package:xm_frontend/data/repositories/authentication/authentication_repository.dart';
import 'package:xm_frontend/data/repositories/object/object_repository.dart';
import 'package:xm_frontend/utils/helpers/helper_functions.dart';
import 'package:flutter/scheduler.dart';
import '../../../data/repositories/user/user_repository.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';
import '../../media/models/image_model.dart';
import '../models/user_model.dart';
import '../models/company_model.dart';

/// Controller for managing admin-related data and operations
class UserController extends TBaseController<UserModel> {
  RxList<bool> selectedRows = <bool>[].obs;
  static UserController get instance => Get.find();

  // Observable variables
  RxBool loading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;
  Rx<UserModel> userRetrived = UserModel.empty().obs;

  RxString userProfileUrl = ''.obs;
  final displayNameController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  final tokenController = TextEditingController();
  final searchController = TextEditingController();

  final selectedObjectId = 0.obs;

  Rx<Uint8List?> memoryBytes = Rx<Uint8List?>(null);

  RxBool hasImageChanged = false.obs;

  final paginatedPage = 0.obs;
  var userModel = UserModel.empty().obs; // Make it observable

  // Dependencies
  final userRepository = Get.put(UserRepository());
  //final p_controller = Get.put(PermissionController());

  //final _objectRepository = Get.find<ObjectRepository>();

  RxList<ObjectModel> objectsList = <ObjectModel>[].obs;
  RxList<UserRoleModel> userRolesList = <UserRoleModel>[].obs;
  RxList<CompanyModel> companiesList = <CompanyModel>[].obs;

  var selectedObjectIds = <int>[].obs;

  final selectedRoleId = 0.obs;
  final selectedCompanyId = 0.obs;

  RxBool filtersApplied = false.obs; // Track if filters are applied

  // for filters
  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);

  RxInt selectedStatusId = (-1).obs; // -1 means all statuses
  RxInt selectedRoleFilterId = (-1).obs; // 0 = All
  RxInt selectedStatusFilterId = (-1).obs; // 0 = All

  RxList<UserModel> allUsers = <UserModel>[].obs;
  RxList<UserModel> filteredUsers = <UserModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    AuthenticationRepository.instance.refreshCurrentUserDetails();
    // Get users
    loadUsers();
    loadAllUserRoles();
    ever(filteredUsers, (_) {
      selectedRows.value = List<bool>.filled(filteredUsers.length, false);
    });
    //  fetchUsersAndTranslateFields();
  }
String getSelectedCompanyName() {
  final company = companiesList.firstWhereOrNull(
    (c) => c.id == selectedCompanyId.value,
  );
  return company?.name ?? '';
}
  /// Fetches user details from the repository
  Future<UserModel> fetchUserDetails() async {
    try {
      loading.value = true;
      //if (user.value.id == null || user.value.id!.isEmpty) {
      //  debugPrint('Fetching User Details');
      final userR = await userRepository.fetchUserDetails();
      debugPrint('User from fetchUserDetails controller: ${userR.toJson()}');
      
      user.value = userR;

      debugPrint('User from user controller: ${user.value.toJson()}');

      var translatedRoleName = await TranslationApi.smartTranslate(
        user.value.roleNameExt!,
      );

      debugPrint('Translated Role Name: $translatedRoleName');

      // user.value.translatedRoleNameExt = translatedRoleName;

      user.update((val) => val?.translatedRoleNameExt = translatedRoleName);

      firstNameController.text = user.value.firstName;
      lastNameController.text = user.value.lastName;
      displayNameController.text = user.value.displayName;

      loading.value = false;

      debugPrint('User Details Refreshed: ${user.value.toJson()}');
      return userR;
    } catch (e) {
       debugPrint('Error fetching user details: $e');
      //TLoaders.errorSnackBa    title: 'Something went wrong.',message: e.toString(),
      
      return UserModel.empty();
    }
  }





  void loadAllUserRoles() async {
    try {
      final result = await userRepository.getAllUserRoles();

      // before assing trsnalte the role names
      for (final role in result) {
        role.nameTranslated = await TranslationApi.smartTranslate(role.name);
      }

      userRolesList.assignAll(result);

      //   debugPrint('User Roles Loaded: ${userRolesList.length}');
    } catch (e) {
      //   Get.snackbar('Error', 'Failed to load user roles: $e');
    } finally {
      //  loading.value = false;
    }
  }
/*
  void loadAllObjects() async {
    try {
      final result = await _objectRepository.getAllObjects();

      objectsList.assignAll(result);
      //    debugPrint('Buildings Loaded: ${buildingsList.length}');
    } catch (e) {
      //   Get.snackbar('Error', 'Failed to load buildings: $e');
    } finally {
      //  loading.value = false;
    }
  }
*/
  void toggleObject(int id) {
    if (selectedObjectIds.contains(id)) {
      selectedObjectIds.remove(id);
    } else {
      selectedObjectIds.add(id);
    }
  }

  void pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true, // So we can preview it in memory
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;

      memoryBytes.value = file.bytes;
      hasImageChanged.value = true;

      userProfileUrl.value = file.name;
      userModel.value.profilePicture=file.name;
    }
  }

  Future<UserModel> fetchUserDetailsById(int userId) async {
    loading.value = true;
    try {
      if (userId != 0) {
        final user = await userRepository.fetchUserDetailsById(userId);

        if (user == null) {
          // handle null gracefully
          debugPrint('No user found with id $userId');
          // Optionally clear fields or return an empty user model
          userRetrived.value = UserModel.empty();
        } else {
          // userRetrived.value = user;
          userRetrived.update((val) {
            // Update the user object with the retrieved data
            val?.id = user.id;
            val?.firstName = user.firstName;
            val?.lastName = user.lastName;
            val?.phoneNumber = user.phoneNumber;
            val?.displayName = user.displayName;
            val?.profilePicture = user.profilePicture;
            val?.email = user.email;
            val?.roleId = user.roleId;
            val?.roleName = user.roleName;
            val?.companyId = user.companyId;
            val?.companyName = user.companyName;
            val?.createdAt = user.createdAt;
            val?.updatedAt = user.updatedAt;
            val?.translatedRoleNameExt = user.translatedRoleNameExt;
            val?.status = user.status;
            val?.statusId = user.statusId;
            val?.roleExtId = user.roleExtId;
          });
        }
      }

      // Populate form fields safely (empty string fallback)
      firstNameController.text = userRetrived.value.firstName ?? '';
      lastNameController.text = userRetrived.value.lastName ?? '';
      phoneController.text = userRetrived.value.phoneNumber ?? '';
      displayNameController.text = userRetrived.value.displayName ?? '';
      userProfileUrl.value = userRetrived.value.profilePicture ?? '';
      emailController.text = userRetrived.value.email ?? '';
      selectedRoleId.value =
          userRetrived.value.roleExtId ?? 0; // Default to 0 if null
      selectedStatusId.value =
          userRetrived.value.statusId ?? -1; // Default to -1 if null

      // get list of user assigned objects
      final assignedObjects = await userRepository.getUserAssignedObjects(
        int.parse(userRetrived.value.id?.toString() ?? '0'),
      );

      selectedObjectIds.clear(); // Clear previous selections
      selectedObjectIds.addAll(
        assignedObjects.map((b) => int.parse(b.id.toString())),
      );
      debugPrint('Selected Object IDs: $selectedObjectIds');
      userModel.value=userRetrived.value;
      return userRetrived.value;
    } catch (e) {
      debugPrint('Error fetching user details: $e');
      // Optionally show a snackbar/toast
      // TLoaders.errorSnackBar(title: 'Something went wrong.', message: e.toString());
      return UserModel.empty();
    } finally {
      loading.value = false;
    }
  }

  void resetUserDetails() {
    // Reset the user details to empty
    userRetrived.value = UserModel.empty();
    firstNameController.clear();
    lastNameController.clear();
    displayNameController.clear();
    phoneController.clear();
    displayNameController.clear();
    userProfileUrl.value = '';
    emailController.clear();
    memoryBytes.value = null;
    hasImageChanged.value = false;
    selectedObjectIds.clear();
    selectedRoleId.value = 0;
  }

  Map<int, String> getTranslatedUserStatuses() {
    return {
      -1: AppLocalization.of(Get.context!).translate("general_msgs.msg_all"),
      1: THelperFunctions.getUserStatusText(1),
      2: THelperFunctions.getUserStatusText(2),
      3: THelperFunctions.getUserStatusText(3),
    };
  }

  List<Map<String, VoidCallback>> getActiveFilters() {
    final List<Map<String, VoidCallback>> filters = [];

    if (selectedStatusFilterId.value != -1) {
      filters.add({
        THelperFunctions.getUserStatusText(selectedStatusFilterId.value): () {
          selectedStatusFilterId.value = -1;
          applyFilters(
            selectedStatusFilterId.value,
            selectedRoleFilterId.value,
            startDate.value,
            endDate.value,
          );
        },
      });
    }

    if (selectedRoleFilterId.value != -1) {
      final selectedRole = userRolesList.firstWhereOrNull(
        (r) => r.id == selectedRoleFilterId.value,
      );
      if (selectedRole != null) {
        filters.add({
          selectedRole.nameTranslated.toString(): () {
            selectedRoleFilterId.value = -1;
            applyFilters(
              selectedStatusFilterId.value,
              selectedRoleFilterId.value,
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
                selectedStatusFilterId.value,
                selectedRoleFilterId.value,
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
                selectedStatusFilterId.value,
                selectedRoleFilterId.value,
                startDate.value,
                endDate.value,
              );
            },
      });
    }

    return filters;
  }

  void filterItemsWithSearch([String query = '']) {
    // print(
    //   "Filtering users with selectedRoleFilterId.value = ${selectedRoleFilterId.value}",
    // );
    // allItems.forEach((item) {
    //   print("User: ${item.firstName} ${item.lastName}, roleId: ${item.roleId}");
    // });

    final results =
        allItems.where((item) {
          // 1. Search query: allow empty (show all)
          final matchesSearch =
              query.isEmpty || containsSearchQuery(item, query);

          // 2. Status filter: allow "All" (-1)
          final matchesStatus =
              selectedStatusFilterId.value == -1 ||
              (item.statusId != null &&
                  item.statusId == selectedStatusFilterId.value);

          // 3. Role filter: allow "All" (-1)
          final int? userRoleId = item.roleExtId;
          final matchesRole =
              selectedRoleFilterId.value == -1 ||
              (userRoleId != null && userRoleId == selectedRoleFilterId.value);

          // 4. Date filters: handle nulls
          final matchesStartDate =
              startDate.value == null ||
              (item.createdAt != null &&
                  (item.createdAt!.isAfter(startDate.value!) ||
                      item.createdAt!.isAtSameMomentAs(startDate.value!)));
          final matchesEndDate =
              endDate.value == null ||
              (item.createdAt != null &&
                  (item.createdAt!.isBefore(endDate.value!) ||
                      item.createdAt!.isAtSameMomentAs(endDate.value!)));

          return matchesSearch &&
              matchesStatus &&
              matchesRole &&
              matchesStartDate &&
              matchesEndDate;
        }).toList();

    filteredItems.assignAll(results);

  selectedRows.value = List<bool>.filled(filteredItems.length, false); // <-- Add 
  }

  bool _getStatusFilter(int? status) {
    return selectedStatusId.value == -1 || status == selectedStatusId.value;
  }

  void applyFilters(int statusId, int roleId, DateTime? start, DateTime? end) {
    selectedStatusFilterId.value = statusId;

    selectedRoleFilterId.value = roleId;
    startDate.value = start;
    endDate.value = end;

    filterItemsWithSearch(searchController.text);
  }

  void clearFilters() {
    selectedStatusFilterId.value = -1;
    selectedRoleFilterId.value = -1;
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
  void updateUserInformation( ) async 
  {
      loading.value = true;
      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        // TFullScreenLoader.stopLoading();
        return;
      }

      // save the temporary user details
      final savedUser = user.value;

      // check is userretrived is not empty or null
      if (userRetrived.value.id!.isEmpty) {
      } else {
        user.value = userRetrived.value;
        //    debugPrint('User Retrieved: ${user.value.toJson()}');
      }
      updateUserInfo(user.value);
  }
  Future<bool> updateUserInfo(UserModel u_user) async {
    try {
      // user.update((val) {
      //   val = userRetrived.value;
      // });

      // Form Validation
if (!formKey.currentState!.validate()) {
  loading.value = false; // <-- Add this line
  return false;
}
    
      u_user.firstName = firstNameController.text.trim();
      u_user.lastName = lastNameController.text.trim();
      u_user.displayName = displayNameController.text.trim();
      u_user.profilePicture = userProfileUrl.value;
      u_user.phoneNumber = phoneController.text.trim();
      u_user.companyId = selectedCompanyId.value;
      u_user.roleId = selectedRoleId.value;
      //user.roleExtId = selectedRoleId.value;

      // debugPrint('User Details: ${user.toJson()}');

      final isUserUpdated = await userRepository.updateUserDetails(u_user);
      
      debugPrint('Is User Updated: $isUserUpdated');

      user.value=u_user;
      //user.refresh();

      loading.value = false;
      debugPrint('Is User Refreshed: $isUserUpdated');


if (isUserUpdated) {
  SchedulerBinding.instance.addPostFrameCallback((_) {
    debugPrint('User Updated: ${user.value.toJson()}');
 

    // Show snackbar after navigation and context is available
    Future.delayed(const Duration(milliseconds: 200), () {
      if (Get.context != null) {
        TLoaders.successSnackBar(
          title: AppLocalization.of(Get.context!).translate('general_msgs.msg_info'),
          message: AppLocalization.of(Get.context!).translate('general_msgs.msg_data_updated'),
        );
      }
    });
  });
     return isUserUpdated;
     
}
 else {
        TLoaders.errorSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_error'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_data_failed'),
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
    return false;
  }

  Future<void> submitUser() async {
    try {
      if (!formKey.currentState!.validate()) return;

      loading.value = true;

      if (selectedRoleId.value == 0) {
        TLoaders.errorSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_error'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('tab_users_screen.lbl_role_is_required'),
        );
        return;
      }

      var statusCode = 0; // 0 means exists, 1 created new tenant , 2 failed

      var roleId = 2; // default for company users

      final companyId = AuthenticationRepository.instance.currentUser!.companyId;
      final response = await UserRepository.instance.createNewUser(
        firstNameController.text,
        lastNameController.text,
        emailController.text,
        phoneController.text,
        roleId,
        int.tryParse(companyId.toString()) ?? 2
      );

      statusCode = response['status'];

      loading.value = false;
      
      if (statusCode == 1) {
        //  check if selected buuilings has ids so we can assign them
        if (selectedObjectIds.isNotEmpty) {
          // Assign buildings to the user
          final userId = response['data'][0]['user_id'];
          //    debugPrint('User ID: $userId');

          await UserRepository.instance.assignUserToObjectsBatch(
            userId,
            selectedObjectIds,
          );
        }
      
        Get.back(result: true); //  Return `true` to indicate user was created

        // create a invitation record

        final invitationCode = await UserRepository.instance
            .createUserInviationCode(
              emailController.text.trim(),
              response['data'][0]['user_id'],
            );

        debugPrint('Invitation Code: $invitationCode');

        /*
        if (invitationCode.isNotEmpty) {
          // Send email invitation
          final fullName =
              '${firstNameController.text} ${lastNameController.text}';

          final greetings =
              '${AppLocalization.of(Get.context!).translate('general_msgs.msg_mail_dear')} $fullName,';
          final bodyText = AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_mail_body_text_user_invitation');
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
          ).translate('general_msgs.msg_mail_subject_user_invitation');

          final emailSent = await UserRepository.instance
              .sendUserInviationCodeEmail(
                greetings,
                bodyText,
                invitationCodeText,
                invitationCode,
                availableOnText,
                helpText,
                supportText,
                subject,
                emailController.text.trim(),
              );
        }
        */

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
  void resetFields() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    phoneController.clear();
    emailController.clear();
    selectedObjectId.value = 0; // Reset selected object ID

  }
  Future<void> updateTokenByUser(UserModel user) async {
    try {
      loading.value = true;

      // Check Internet Connectivity

      final invitationCode = await UserRepository.instance
          .updateTokenByUser(user.email.trim(), int.parse(user.id!));

      debugPrint('Invitation Code: $invitationCode');
      loading.value = false;
        }
     catch (e) {
      loading.value = false;
      TLoaders.errorSnackBar(
        title: AppLocalization.of(Get.context!).translate('general_msgs.msg_error'),
        message: e.toString(),
      );
    }
  }

  Future<void> sendUserInvitation(UserModel user) async {
    try {
      // create a invitation record

      debugPrint('Sending Invitation for User: ${user.toJson()}');

      final invitationCode = await UserRepository.instance
          .createUserInviationCode(user.email.trim(), int.parse(user.id!));

      debugPrint('Invitation Code: $invitationCode');

      if (invitationCode.isNotEmpty) {
        // Send email invitation
        final fullName = '${user.firstName} ${user.lastName}';

        final greetings =
            '${AppLocalization.of(Get.context!).translate('general_msgs.msg_mail_dear')} $fullName,';
        final bodyText = AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_mail_body_text_user_invitation');
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
        ).translate('general_msgs.msg_mail_subject_user_invitation');

        final emailSent = await UserRepository.instance
            .sendUserInviationCodeEmail(
              greetings,
              bodyText,
              invitationCodeText,
              invitationCode,
              availableOnText,
              helpText,
              supportText,
              subject,
              user.email.trim(),
            );

        if (emailSent) {
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

  void sortByPropertyName<T>(
    int sortColumnIndex,
    bool ascending,
    Comparable Function(UserModel) getProperty,
  ) {
    sortByProperty(sortColumnIndex, ascending, getProperty);
  }

  Future<List<UserModel>> fetchUsersAndTranslateFields() async {
    final users = await userRepository.getAllUsers();

    for (final user in users) {
      user.translatedStatus = await TranslationApi.smartTranslate(
        user.status ?? '',
      );
      user.translatedRoleNameExt = await TranslationApi.smartTranslate(
        user.roleNameExt ?? '',
      );
    }

    debugPrint('Fetched Users: ${users.length}');
    debugPrint('First User: ${users.first.toJson()}');

    debugPrint("fetchUsersAndTranslateFields: ${users.length} users loaded");
    debugPrint("allItems: ${allItems.length}");
    debugPrint("filteredItems: ${filteredItems.length}");

    return users;
  }

  Future<void> loadUsers() async {
    loading.value = true;
    try {
      final users = await userRepository.getAllUsers();

      debugPrint('[User Controller] Load Users: ${users.length}');
      for (final user in users) {
        user.translatedStatus = await TranslationApi.smartTranslate(
          user.status ?? '',
        );

      }
      allUsers.assignAll(users);
      filteredUsers.assignAll(users);
    } catch (e) {
      TLoaders.errorSnackBar(title: "Error", message: "Failed to load users.");
    } finally {
      loading.value = false;
    }
  }

  @override
  Future<List<UserModel>> fetchItems() async {
    debugPrint("Fetching items in UserController fetchItems()");
    return await fetchUsersAndTranslateFields();
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
    final isDeleted = await userRepository.deleteUserById(int.parse(item.id!));
    debugPrint('User Deleted by User Controller');
/*
    if (isDeleted) {
      // deletes user directory for the images
      final companyId = AuthenticationRepository.instance.currentUser!.companyId;
      final containerName = 'docs';
      final directory = 'users/${item.id}';

      await userRepository.deleteUserDirectory(containerName, directory);
    }
    */

    return isDeleted;
  }
}
