import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/data/abstract/base_data_table_controller.dart';
import 'package:xm_frontend/data/models/object_model.dart';
import 'package:xm_frontend/data/models/permission_model.dart';
import 'package:xm_frontend/data/models/unit_model.dart';
import 'package:xm_frontend/data/repositories/authentication/authentication_repository.dart';
import 'package:xm_frontend/data/repositories/object/object_repository.dart';

import 'package:xm_frontend/data/repositories/contract/permission_repository.dart';
import 'package:xm_frontend/data/repositories/unit/unit_repository.dart';
import 'package:xm_frontend/data/repositories/user/user_repository.dart';
import 'package:xm_frontend/features/personalization/controllers/settings_controller.dart';
import 'package:xm_frontend/features/personalization/controllers/user_controller.dart';
import 'package:xm_frontend/features/personalization/models/user_model.dart';
import 'package:xm_frontend/features/shop/controllers/object/object_unit_detail_controller.dart';
import 'package:xm_frontend/utils/constants/colors.dart';
import 'package:xm_frontend/utils/helpers/helper_functions.dart';
import 'package:xm_frontend/utils/helpers/network_manager.dart';
import 'package:xm_frontend/utils/popups/full_screen_loader.dart';
import 'package:xm_frontend/utils/popups/loaders.dart';

class PermissionController extends TBaseController<PermissionModel> {
  static PermissionController get instance => Get.find();

  @override
  bool containsSearchQuery(PermissionModel item, String query) {
    // Example implementation: search by contractCode, objectName, or user names/emails
    final lowerQuery = query.toLowerCase();
    final contractCode = item.permissionId ?? 0;
    final objectName = item.objectName?.toLowerCase() ?? '';
    final userMatches = (item.users ?? []).any((user) =>
      user.displayName.toLowerCase().contains(lowerQuery) ||
      user.email.toLowerCase().contains(lowerQuery)
    );
    return contractCode.toString().contains(lowerQuery) ||
           objectName.contains(lowerQuery) ||
           userMatches;
  }

  final _permissionRepository = Get.put(PermissionRepository());
  final _unitRepository = Get.put(UnitRepository());
  final _objectRepository = Get.put(ObjectRepository());
  final auth_controller = AuthenticationRepository.instance;
  final formKey = GlobalKey<FormState>();

  RxBool isDataUpdated = false.obs;


  final contractReferenceController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final users = <UserModel>[].obs;
  final selectedUsers = <UserModel>[].obs;
  final RxInt selectedStatus = 3.obs; // default to Pending

  RxBool filtersApplied = false.obs; // Track if filters are applied

  final Rx<PermissionModel> _permissionModel = PermissionModel.empty().obs;

  Rx<PermissionModel> get permissionModel => _permissionModel;

  final paginatedPage = 0.obs;

  var loading = false.obs;

  var searchQueryValue = "".obs;

  RxBool loadingUsers = true.obs;
  RxBool loadingPermissions = true.obs;
  // This will be used to filter users by name or email
  final filteredUsers = <UserModel>[].obs;
  RxList<UnitModel> unitsList = <UnitModel>[].obs;
  RxList<ObjectModel> objectsList = <ObjectModel>[].obs;

  // this is for when creating a new contract from all contracts table
  RxInt selectedUnitId = 0.obs;
  RxInt selectedObjectId = 0.obs;
  RxInt selectedUserId = 0.obs;

  RxList<PermissionModel> allPermissions = <PermissionModel>[].obs;
  RxList<PermissionModel> filteredPermissions = <PermissionModel>[].obs;
  RxList<PermissionModel> userPermissions = <PermissionModel>[].obs;
  RxList<bool> selectedRows = <bool>[].obs;

  // Ensure the table source uses this getter
  @override
  RxList<PermissionModel> get filteredItems => filteredPermissions;

 
  RxList<PermissionModel> get userItems => userPermissions;

  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);

  RxInt selectedStatusId = (-1).obs; // -1 means all statuses
  RxInt selectedObjectFilterId = 0.obs; // 0 = All

  final userController = Get.find<UserController>();

  @override
  void onInit() {
    // Retrieve stored email and password if "Remember Me" is selected
    debugPrint('PermissionController initialized');
    super.onInit();
    //loadUsers();
    //loadAllObjects();
    loadPermissions();
    debugPrint('[PermissionController]: filteredPermissions.length: ${filteredPermissions.length} ');
    ever(filteredPermissions, (_) {
      selectedRows.value = List<bool>.filled(filteredPermissions.length, false);
    });
  }
  @override
  Future<void> refreshData() async {
    final users = await loadPermissions();
  }
  
  Future<void> loadPermissions() async {
    loading.value = true;
    try {
      final permissions =
          await _permissionRepository.getAllPermissions();

      debugPrint('Loaded Permissions: ${permissions.length}');

      allPermissions.assignAll(permissions);
      //userPermissions.assignAll(permissions);
      //selectedRows.value = List<bool>.filled(userPermissions.length, false);
      debugPrint('[PermissionController]: userPermissions.length: ${userPermissions.length}');

    } catch (e) {
      TLoaders.errorSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_error'),
        message: e.toString(),
      );
    } finally {
      loading.value = false;
    }
  }

  // Load tenants and update state
  void loadUsers() async {
    try {
      loadingUsers.value = true; // Start loading
      // Simulate a delay or actual data fetching logic
      await Future.delayed(Duration(seconds: 1)); // Mock async fetch

      debugPrint(_permissionModel.value.toJson().toString());

      // Assuming permissionModel is already populated  
      filteredUsers.value = _permissionModel.value.users ?? [];

      debugPrint('Filtered Users: ${filteredUsers.length}');

      loadingUsers.value = false; // Mark loading as done
    } catch (e) {
      loadingUsers.value = false;
      TLoaders.errorSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_error'),
        message: e.toString(),
      );
    }
  }
  void loadAllObjectUnits(int objectId) async {
    try {
      final result = await _objectRepository.fetchObjectUnits(
        objectId,
      );

      unitsList.assignAll(result);

      debugPrint('Object Units: ${unitsList.length}');
      debugPrint('Object ID: $objectId');
    } catch (e) {
      TLoaders.errorSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_error'),
        message: e.toString(),
      );
    } finally {
      loading.value = false;
    }
  }


  bool isUserAdmin()
  {
      final user=auth_controller.currentUser;
      if (user != null) {
        if (user.roleId == 1) // Check if user has the specific role
            return true;
        else
              return false;
      }
      else
        return false; 
  }
  
  bool CheckObjectForCurrentUser( int objectId) 
  {

    final userId = int.tryParse(auth_controller.currentUser?.id ?? '');
    if (userId != null) {
      return CheckObjectForUser(userId, objectId);
    }
    return false;
  }
  bool CheckEditForCurrentUser( int objectId) 
  {

    final userId = int.tryParse(auth_controller.currentUser?.id ?? '');
    if (userId != null) {
      return CheckEditForUser(userId, objectId);
    }
    return false;
  }
    bool CheckEditForUser(int userId, int objectId) 
  {

final user = userController.allItems.firstWhereOrNull((u) => u.id == userId.toString());

  debugPrint('Checking permissions for object $objectId and  user: ${user?.id} and role: ${user?.roleId}.');
  if (user == null) return false;

  if (user.roleId == 1) // Check if user has the specific role
    return true;
  else {
    filterPermissionsByUserId(userId);

    debugPrint('userPermissions for userId $userId:');
    for (final perm in userPermissions) {
      debugPrint('  perm.objectId: ${perm.objectId}, perm.roleId: ${perm.roleId}');
    }

    final matching = userPermissions.where((perm) =>
      perm.objectId == objectId && (perm.roleId == 1 || perm.roleId == 2)
    ).toList();

    debugPrint('Matching permissions for objectId $objectId: ${matching.length}');
    for (final perm in matching) {
      debugPrint('  MATCH: perm.objectId: ${perm.objectId}, perm.roleId: ${perm.roleId}');
    }

    return matching.isNotEmpty; // <-- Add this line to return a bool
  }
}

  bool CheckObjectForUser(int userId, int objectId) 
  {

  final user = userController.allItems.firstWhereOrNull((u) => u.id == userId.toString());

  debugPrint('Checking permissions for object $objectId and  user: ${user?.id} and role: ${user?.roleId}.');
  if (user == null) return false;

  if (user.roleId == 1) // Check if user has the specific role
    return true;
  else {
    //return false;
         filterPermissionsByUserId(userId);
  // Check if any permission for this user has the given objectId
        return userPermissions.any((perm) => perm.objectId == objectId);
    }
}
  bool CheckObjectForUserModel(UserModel user, int objectId) 
  {


  debugPrint('Checking permissions for object $objectId and  user: ${user?.id} and role: ${user?.roleId}.');
  if (user == null) return false;

  if (user.roleId == 1) // Check if user has the specific role
    return true;
  else {
    //return false;
         filterPermissionsByUserId(user.id != null ? int.parse( user.id!) : 0);
  // Check if any permission for this user has the given objectId
        return userPermissions.any((perm) => perm.objectId == objectId);
    }
  }
  void filterPermissionsByUserId(int userId) {

  userPermissions.clear(); // Always start empty
  final results = allPermissions.where((perm) => perm.userId == userId).toList();

  debugPrint('Filtered Permissions for user ID $userId: ${results.length}');  
  userPermissions.assignAll(results);
  debugPrint('Filtered Permissions for user ID $userId: ${userPermissions.length}');  

  selectedRows.value = List<bool>.filled(userPermissions.length, false);
  }
bool filterAndCheckObjectForUser(int userId, int objectId) {
  filterPermissionsByUserId(userId);

  // Check if any permission for this user has the given objectId
  return userPermissions.any((perm) => perm.objectId == objectId);
}

  void loadAllObjects() async {
    try {
      final result = await _objectRepository.getAllObjects();
      final updatedUser = await userController.fetchUserDetails();

      final userObjectRestrictions = updatedUser.objectPermissionIds ?? [];

      // debugPrint('User building restrictions: $userBuildingRestrictions');

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
      TLoaders.errorSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_error'),
        message: e.toString(),
      );
    } finally {
      loading.value = false;
    }
  }

  Future<void> loadPendingContracts() async {
    // final all = await _contractRepository.getAllBuildingContracts();
    // pendingContracts.assignAll(
    //   all.where((c) => c.statusId == 3),
    // ); // Status 3 = pending
  }

  Future<void> initializeContractData(int permissionId) async {
    _permissionModel.value = await _permissionRepository.fetchPermissionById(
      permissionId,
    );

    // Fetch assigned tenants
    /*
    final assignedUsers = await UserRepository.instance
        .fetchUsersByContractId(int.parse(_permissionModel.value.id!));
    _permissionModel.value.users = assignedUsers;


    // Pre-fill form
    contractReferenceController.text = _permissionModel.value.contractCode ?? '';


    // Pre-select assigned users
    selectedUsers.value =
        users.where((t) => assignedUsers.any((a) => a.id == t.id)).toList();

        */
  }

  String statusIdToLocalizedText(BuildContext context, int statusId) {
    switch (statusId) {
      case 1:
        return AppLocalization.of(context).translate('general_msgs.msg_active');
      case 2:
        return AppLocalization.of(
          context,
        ).translate('general_msgs.msg_terminated');
      case 3:
        return AppLocalization.of(
          context,
        ).translate('general_msgs.msg_pending');
      default:
        return AppLocalization.of(
          context,
        ).translate('general_msgs.msg_unknown');
    }
  }

  void pickStartDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2080),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary:
                  TColors.primary, // Main picker color (selected day, header)
              onPrimary:
                  Colors.white, // Text on primary (e.g., selected day text)
              //  onSurface: TColors.text,  // Default text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: TColors.primary, // Button text (Cancel/OK)
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      final formatted = DateFormat('dd.MM.yyyy').format(date);
      startDateController.text = formatted;
    }
  }

  void editPickStartDate(BuildContext context, DateTime initDate) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2080),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary:
                  TColors.primary, // Main picker color (selected day, header)
              onPrimary:
                  Colors.white, // Text on primary (e.g., selected day text)
              //  onSurface: TColors.text,  // Default text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: TColors.primary, // Button text (Cancel/OK)
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      final formatted = DateFormat('dd.MM.yyyy').format(date);
      startDateController.text = formatted;
    }
  }

  void editPickEndDate(BuildContext context, DateTime initDate) async {
    // check initDate is not null

    final date = await showDatePicker(
      context: context,
      initialDate: initDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2080),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary:
                  TColors.primary, // Main picker color (selected day, header)
              onPrimary:
                  Colors.white, // Text on primary (e.g., selected day text)
              //  onSurface: TColors.text,  // Default text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: TColors.primary, // Button text (Cancel/OK)
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      final formatted = DateFormat('dd.MM.yyyy').format(date);
      endDateController.text = formatted;
    }
  }

  Future<void> loadNonContractUsers(int oId) async {
    try {
      loading.value = true;

      int? objectId;

      try {
        // Attempt to get the object ID from the current unit
        objectId =
            ObjectUnitDetailController.instance.unit.value.objectId;
      } catch (e) {
        objectId = 0; // Fallback to 0 if not available
      }

      if (objectId == null || objectId == 0) {
        // If objectId is still 0, use the provided oId
        objectId = oId;
      }

      if (oId != 0) {
        objectId = oId;
      }

 
    } catch (e) {
      TLoaders.errorSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_error'),
        message: e.toString(),
      );
    } finally {
      loading.value = false;
    }
  }

  Future<void> loadselectedObjectNonContractUsers(int objectId) async {
    try {
      loading.value = true;

      debugPrint(
        'loadselectedObjectNonContractUsers Object ID: $objectId',
      );
    } catch (e) {
      TLoaders.errorSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_error'),
        message: e.toString(),
      );
    } finally {
      loading.value = false;
    }
  }

  Future<void> loadNonContractUsersMerged(PermissionModel contract) async {
    try {
      loading.value = true;

      final objectId =
          ObjectUnitDetailController.instance.unit.value.objectId;

      debugPrint('loadNonContractUsers Object ID: $objectId');


      // Merge with assigned users from the contract
      final assigned = contract.users ?? [];

      debugPrint('assigned Users: ${assigned.length}');


      debugPrint('Merged Users: ${users.length}');

      // Now preselect the assigned users
      selectedUsers.value =
          users
              .where(
                (t) => assigned.any((a) => a.id.toString() == t.id.toString()),
              )
              .toList();
    } catch (e) {
      TLoaders.errorSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_error'),
        message: e.toString(),
      );
    } finally {
      loading.value = false;
    }
  }

  Future<void> submitContract() async {
    // the parameter is used when creating a new contract from assigned unit
    try {
      // Start Loading
      loading.value = true;

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        loading.value = false;
        return;
      }

      // Form Validation
      if (!formKey.currentState!.validate()) {
        //   TFullScreenLoader.stopLoading();
        loading.value = false;
        return;
      }
      debugPrint('Selected Status: ${selectedStatus.value}');
      debugPrint('Selected Users: ${selectedUsers.length}');
      debugPrint('Selected Unit ID: ${selectedUnitId.value}');
      debugPrint('Selected Object ID: ${selectedObjectId.value}');

      
      if (startDateController.text.isNotEmpty) {
        _permissionModel.value.startDate = DateFormat(
          'dd.MM.yyyy',
        ).parse(startDateController.text.trim());
      } else {
        _permissionModel.value.startDate = null;
      }

      _permissionModel.value.users = selectedUsers;

    
      // Remove Loader
      loading.value = false;
 

        TLoaders.successSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_info'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_data_submitted'),
        );
      update();
    } catch (e) {
      debugPrint('Error from catch submit contrat: $e');
      loading.value = false;
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_error'),
        message: e.toString(),
      );
    }
  }

  Future<void> submitContractFromUnitAssign(
    int assignedUnitId,
    int objectId,
  ) async {
    // the parameter is used when creating a new contract from assigned unit
    try {
      // Start Loading
      loading.value = true;

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        loading.value = false;
        return;
      }

      selectedUnitId.value = assignedUnitId;
      selectedObjectId.value = objectId;

      debugPrint('Selected Status: ${selectedStatus.value}');
      debugPrint('Selected Users: ${selectedUsers.length}');
      debugPrint(
        'Selected Unit ID  submitContractFromUnitAssign: ${selectedUnitId.value}',
      );

      debugPrint('Selected Object ID: ${selectedObjectId.value}');


        TLoaders.successSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_info'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_data_submitted'),
        );

      // Update UI Listeners
      update();
    } catch (e) {
      debugPrint('Error from catch submit contrat: $e');
      loading.value = false;
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_error'),
        message: e.toString(),
      );
    }
  }

  Future<void> submitContractUpdate(PermissionModel contract) async {
    try {
      // Start Loading
      loading.value = true;

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        loading.value = false;
        return;
      }

      // Form Validation
      if (!formKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        loading.value = false;
        return;
      }

      // Check if any user is selected and statusId is not 3 (pending)
      if (selectedUsers.isEmpty && selectedStatus.value != 3) {
        TLoaders.errorSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_error'),
          message: AppLocalization.of(Get.context!).translate(
            'edit_contract_screen.error_msg_please_select_at_least_one_tenant',
          ),
        );
        loading.value = false;
        return;
      }

      var updateUnitStatus = false;
      var newUnitStatus = 0;

      // Check for active contract and handle accordingly


      debugPrint(
        'updateUnitStatus: $updateUnitStatus, newUnitStatus: $newUnitStatus',
      );

      bool isContractUpdated = false;
      bool isContractUpdatedSuccessfully = false;

      final parsedStartDate =
          startDateController.text.trim().isNotEmpty
              ? DateFormat('dd.MM.yyyy').parse(startDateController.text.trim())
              : null;

      final parsedEndDate =
          endDateController.text.trim().isNotEmpty
              ? DateFormat('dd.MM.yyyy').parse(endDateController.text.trim())
              : null;

   
      // Remove Loader
      loading.value = false;
 

      update();
    } catch (e) {
      debugPrint('Error from catch submitContractUpdate: $e');
      loading.value = false;
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_error'),
        message: e.toString(),
      );
    }
  }


  Future<bool> removeUserFromObject(int objectId, int userId) async {
    try {
      // Start Loading
      loading.value = true;

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        loading.value = false;
        return false;
      }
      bool isRemoved = false;

      isRemoved = await _permissionRepository.removeUserFromObject(
        objectId,
        userId,
      );

      // Remove Loader
      loading.value = false;

      if (isRemoved) {
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
        return false;
      }

      // Update UI Listeners
      update();
      return true;
    } catch (e) {
      debugPrint('Error from catch removeUserFromContract: $e');
      loading.value = false;
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_error'),
        message: e.toString(),
      );
      return false;
    }
  }

  Future<bool> createPermission(int userId, int objectId,int roleId) async {
    try {
      // Start Loading
      loading.value = true;

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        loading.value = false;
        return false;
      }
      bool isCreated = false;
      debugPrint('[Permission Controller] Creating permission with User ID: $userId, Object ID: $objectId, Role ID: $roleId');

      isCreated = await _permissionRepository.createPermission(
        userId,
        objectId,
        roleId
      );

      // Remove Loader
      loading.value = false;

      if (isCreated) {
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


      // Update UI Listeners
      update();
     return isCreated;
    } catch (e) {
      debugPrint('Error from catch createPermission: $e');
      loading.value = false;
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_error'),
        message: e.toString(),
      );
      return false;
    }
  }


  Future<bool> removePermission(PermissionModel permission) async {
    try {
      // Start Loading
      loading.value = true;

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        loading.value = false;
        return false;
      }
      bool isRemoved = false;

      isRemoved = await _permissionRepository.removePermission(
        permission,
      );

      // Remove Loader
      loading.value = false;

      if (isRemoved) {
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
        return false;
      }

      // Update UI Listeners
      update();
      return true;
    } catch (e) {
      debugPrint('Error from catch removeUserFromContract: $e');
      loading.value = false;
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_error'),
        message: e.toString(),
      );
      return false;
    }
  }

  void filterUsers(String query) {
    searchQueryValue.value = query;

    if (query.isEmpty) {
      filteredUsers.value = _permissionModel.value.users ?? [];
    } else {
      filteredUsers.value =
          _permissionModel.value.users?.where((user) {
            return user.displayName.toLowerCase().contains(
                  query.toLowerCase(),
                ) ||
                user.email.toLowerCase().contains(query.toLowerCase());
          }).toList() ??
          [];
    }
  }

  Future<File?> pickFile() async {
    // Show the file picker dialog and allow the user to select a file
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) {
      return File(result.files.single.path!); // Return the file
    } else {
      return null; // No file selected
    }
  }

  Future<bool> deleteDocumentFromAzure(
    String fileName,
    String containerName,
    String documentId,
  ) async {
    try {
      if (fileName == '') {
        debugPrint('No file name found.');
        return false;
      }

      // Start Loading
      loading.value = true;

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        loading.value = false;
        return false;
      }
      bool isFileDeleted = false;

      isFileDeleted = await _permissionRepository.deleteDocument(
        fileName,
        containerName,
        documentId,
      );

      // Remove Loader
      loading.value = false;

      if (isFileDeleted) {
        TLoaders.successSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_info'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_document_deleted'),
        );
      } else {
        TLoaders.errorSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_error'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_document_delete_failed'),
        );
        return false;
      }

      // Update UI Listeners
      update();
      return true;
    } catch (e) {
      debugPrint('Error from catch uploadDocumentToAzure: $e');
      loading.value = false;
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_error'),
        message: e.toString(),
      );
      return false;
    }
  }

  Future<bool> uploadDocumentToAzure(File pickedFile, int contractId) async {
    try {
      if (pickedFile == null) {
        debugPrint('No file selected.');
        return false;
      }

      final directoryName =
          "contracts/$contractId"; // Set the directory for storage

      // Start Loading
      loading.value = true;

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        loading.value = false;
        return false;
      }
      bool isFileUploaded = false;

      isFileUploaded = await _permissionRepository.uploadNewDocument(
        contractId,
        directoryName,
        pickedFile,
      );

      // Remove Loader
      loading.value = false;

      if (isFileUploaded) {
        TLoaders.successSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_info'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_new_document_uploaded_successfully'),
        );
      } else {
        TLoaders.errorSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_error'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_document_failed'),
        );
        return false;
      }

      // Update UI Listeners
      update();
      return true;
    } catch (e) {
      debugPrint('Error from catch uploadDocumentToAzure: $e');
      loading.value = false;
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_error'),
        message: e.toString(),
      );
      return false;
    }
  }

  Future<bool> renameFile(String documentId, String newFileName) async {
    try {
      // Start Loading
      loading.value = true;

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        loading.value = false;
        return false;
      }
      bool isRenameFileUpdatedSuccessfuly = false;

      isRenameFileUpdatedSuccessfuly = await _permissionRepository.updateFileName(
        documentId,
        newFileName,
      );

      // Remove Loader
      loading.value = false;

      debugPrint(
        'isRenameFileUpdatedSuccessfuly: $isRenameFileUpdatedSuccessfuly',
      );

      if (isRenameFileUpdatedSuccessfuly) {
        Get.back(result: newFileName);
        TLoaders.successSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_info'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_rename_file_success'),
        );
      } else {
        TLoaders.errorSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_error'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_rename_file_failed'),
        );
        return false;
      }

      // Update UI Listeners
      update();
      return true;
    } catch (e) {
      debugPrint('Error from catch renameFile: $e');
      loading.value = false;
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_error'),
        message: e.toString(),
      );
      return false;
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

    debugPrint(
      'applyFilters: statusId=$statusId, objectId=$objectId, start=$start, end=$end',
    );

    filterItemsWithSearch(searchTextController.text);
  }

  void clearFilters() {
    selectedStatusId.value = -1;
    selectedObjectFilterId.value = 0;
    startDate.value = null;
    endDate.value = null;
    searchTextController.clear();
    filterItemsWithSearch('');
  }

  void clearStartDate() {
    startDate.value = null;
  }

  void clearEndDate() {
    endDate.value = null;
  }

  void clearFields() {
    contractReferenceController.clear();
    startDateController.clear();
    endDateController.clear();
    selectedUsers.clear();
    selectedStatus.value = 3; // Default to pending
  }

  void resetFields() {
    contractReferenceController.clear();
    startDateController.clear();
    endDateController.clear();
    selectedUsers.clear();
    selectedStatus.value = 3;
    selectedObjectId.value = 0;
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

  void filterItemsWithSearch([String query = '']) {
    final results =
        allItems.where((item) {
          final matchesSearch = containsSearchQuery(item, query);


          final matchesObject =
              selectedObjectFilterId.value == 0 ||
              item.objectId == selectedObjectFilterId.value;

          final matchesStartDate =
              startDate.value == null ||
              item.startDate!.isAfter(startDate.value!);

          final matchesEndDate =
              endDate.value == null || item.startDate!.isBefore(endDate.value!);

          // if (selectedStatusId.value == 4) {
          //   debugPrint(
          //     'Evaluating ${item.fullName} → contractStatus=${item.contractStatus}',
          //   );
          // }

          return matchesSearch &&
  
              matchesObject &&
              matchesStartDate &&
              matchesEndDate;
        }).toList();

    filteredItems.assignAll(results);
    selectedRows.value = List<bool>.filled(filteredItems.length, false);
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

  @override
  Future<List<PermissionModel>> fetchItems() async {
    // return await _contractRepository.getAllBuildingContracts();

    final result = await _permissionRepository.getAllCompanyObjectsContracts();

    final updatedUser = await userController.fetchUserDetails();

    final userObjectRestrictions = updatedUser.objectPermissionIds ?? [];

    debugPrint('User object restrictions: $userObjectRestrictions');

    final filteredContractsData =
        result
            .where(
              (contract) => userObjectRestrictions.contains(
                int.parse(contract.objectId.toString()),
              ),
            )
            .toList();

    return filteredContractsData;
  }

  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
      (PermissionModel b) => b.permissionId.toString().toLowerCase(),
    );
  }

  void sortByObject(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
      (PermissionModel b) => b.objectName.toString().toLowerCase(),
    );
  }

  void sortByStartDate(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
      (PermissionModel b) => b.startDate?.toIso8601String() ?? '',
    );
  }

  void sortByEndDate(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
      (PermissionModel b) => b.endDate?.toIso8601String() ?? '',
    );
  }

  @override
  Future<bool> deleteItem(PermissionModel item) async {
    return await _permissionRepository.deleteContract(int.parse(item.id!));
  }
}
