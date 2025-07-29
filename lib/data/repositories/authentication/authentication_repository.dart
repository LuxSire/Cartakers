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

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final UserService _userService = Get.put(UserService());

  // ── Make the user reactive ───────────────────────
  final Rxn<UserModel> _currentUser = Rxn<UserModel>();

  UserModel? get currentUser => _currentUser.value;
  set currentUser(UserModel? u) => _currentUser.value = u;

  bool get isAuthenticated => _currentUser.value != null;

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
        final response = await _userService.getCompanyById(int.parse(userId));
        _currentUser.value = UserModel.fromJson(response);
      } catch (e) {
        debugPrint('Failed to fetch user: $e');
        _currentUser.value = null;
      }
    }
  }

  /// LOGIN with email and password
  Future<bool> loginWithEmailAndPassword(String email, String password) async {
    try {
      final response = await _userService.getCompanyByEmail(
        email.trim().toLowerCase(),
      );

      if ((response['id'] ?? 0) > 0) {
        final isPasswordValid = Helpers.verifyPassword(
          password,
          response['password_hash'],
        );
        if (!isPasswordValid) return false;

        _currentUser.value = UserModel.fromJson(response);

        // Persist user‐meta
        await UserPreferences.updateUserField("has_registered", true);
        await UserPreferences.updateUserField("id", response['id'].toString());
        await UserPreferences.updateUserField(
          "agency_id",
          response['agency_id'],
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
        await UserPreferences.updateUserField(
          "profile_pic",
          response['profile_pic'] ?? '',
        );

        // ── Persist only notification preferences from the API ──
        await UserPreferences.updateUserField(
          "is_push_notifications",
          (response['is_push_notifications_enabled'] ?? 1) == 1,
        );
        await UserPreferences.updateUserField(
          "is_email_notifications",
          (response['is_email_notifications_enabled'] ?? 1) == 1,
        );

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
  ) async {
    try {
      return await _userService.registerCompany({
        'email': email,
        'password': hashedPassword,
        'first_name': firstName,
        'last_name': lastName,
        'company_id': companyid,
      });
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
