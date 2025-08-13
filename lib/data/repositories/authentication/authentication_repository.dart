// lib/features/personalization/controllers/authentication_repository.dart

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:xm_frontend/app/utils/helpers.dart';
import 'package:xm_frontend/app/utils/user_preferences.dart';
import 'package:xm_frontend/data/api/services/user_service.dart';

import 'package:xm_frontend/features/personalization/controllers/user_controller.dart';
import 'package:xm_frontend/features/personalization/models/user_model.dart';
import 'package:xm_frontend/routes/routes.dart';
import 'package:xm_frontend/data/repositories/user/user_repository.dart';

class AuthenticationRepository extends GetxController { 
  static AuthenticationRepository get instance => Get.find();

  final UserService _userService = Get.put(UserService());

  // ── Make the user reactive ───────────────────────
  final Rxn<UserModel> _currentUser = Rxn<UserModel>();

  UserModel? get currentUser => _currentUser.value;
  set currentUser(UserModel? u) => _currentUser.value = u;

  bool get isAuthenticated => _currentUser.value != null;

  @override
  void onInit() {
    super.onInit();
    // Always refresh permissions when the instance is created
    //refreshCurrentUserDetails();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await loadUserFromPrefs(); // Loads from prefs and fetches real user
  }

  /// Load user from prefs (just the ID) then fetch full user from MySQL
  Future<void> loadUserFromPrefs() async {
    final userId = await UserPreferences.getUserId(); // ID only
    if (userId != null) {
      try {
        await refreshCurrentUserDetails();
        debugPrint('objectPermissions after refresh: ${currentUser?.objectPermissions}');
      } catch (e) {
        debugPrint('Failed to fetch user: $e');
        _currentUser.value = null;
      }
    }
  }
  Future<void> refreshCurrentUserDetails() async {
    final user = await UserRepository.instance.fetchUserDetails();
    currentUser = user;
  }

  /// LOGIN with email and password
  Future<bool> loginWithEmailAndPassword(String email, String password) async {
    try {
      final response = await _userService.getUserByEmail(
        email.trim().toLowerCase(),
      );
      final id = int.tryParse(response['id'].toString()) ?? 0;
      if (id > 0) {
        final isPasswordValid = Helpers.verifyPassword(
          password,
          response['password_hash'],
        );

        debugPrint('Password is $isPasswordValid   $password.  ${response['password_hash']}');

        if (!isPasswordValid) return false;

        _currentUser.value = UserModel.fromJson(response);


        debugPrint('Current user after login');
        // Persist user‐meta
        //await UserPreferences.updateUserField("has_registered", true);
        await UserPreferences.updateUserField("id", response['id'].toString());
        await UserPreferences.updateUserField(
          "company_id",
          response['company_id'],
        );
        await UserPreferences.updateUserField("role_id", response['role_id']);
        await UserPreferences.updateUserField(
          "role_name",
          response['role_name'],
        );
        await UserPreferences.updateUserField(
          "display_name",
          response['display_name'],
        );
        //await UserPreferences.updateUserField(
        //  "profile_pic",
        //  response['profile_pic'] ?? '',
        //);

        debugPrint('Current user after display_name');

        // ── Persist only notification preferences from the API ──
        await UserPreferences.updateUserField(
          "is_push_notifications",
          (response['is_push_notifications_enabled'] ?? 1) == 1,
        );
        await UserPreferences.updateUserField(
          "is_email_notifications",
          (response['is_email_notifications_enabled'] ?? 1) == 1,
        );

        debugPrint('Current user before refresh');

        await refreshCurrentUserDetails(); 
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> validateInvitationCode(String code) async {
    try {
      return await _userService.validateUserInvitationToken(code);
    } catch (e) {
      return {};
    }
  }

  void restoreSession() {
    final storedUserMap = GetStorage().read('AUTH_TOKEN');
    // debugPrint('Restoring session with: $storedUserMap');
    if (storedUserMap != null) {
      currentUser = UserModel.fromJson(storedUserMap);

      final userController = Get.find<UserController>();
      userController.user.value = currentUser!;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    // TODO: implement if needed
  }

  Future<Map<String, dynamic>> registerAdmin(
    String email,
    String hashedPassword,
    String firstName,
    String lastName,
    String companyid,
    String companyName,
  ) async {
    try {
      return await _userService.registerupdateCompany({
        'email': email,
        'password': hashedPassword,
        'name':companyName,
        'last_name': lastName,
        'company_id': companyid,
      });
    } catch (e) {
      return {};
    }
  }
Future<Map<String, dynamic>> registerUser(Map<String, dynamic> userJson) async {
  try {
    // Send userJson as needed (body or query param)
    return await _userService.registerUser(userJson);
  } catch (e) {
    return {};
  }
}

  Future<void> reset() async {
    _currentUser.value = UserModel.empty();

    final controller = Get.find<UserController>();
    controller.user.value = UserModel.empty();
  }

  Future<void> logout() async {
    _currentUser.value = UserModel.empty();

    final controller = Get.find<UserController>();
    controller.user.value = UserModel.empty();

    // optionally clear saved prefs:
    // await UserPreferences.removeUserId();
    Get.offAllNamed(Routes.login);
  }
}
