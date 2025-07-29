// import 'package:shared_preferences/shared_preferences.dart';

// class UserPreferences {
//   static const _userIdKey = 'user_id';

//   // Save user ID
//   static Future<void> saveUserId(String userId) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_userIdKey, userId);
//   }

//   // Get user ID
//   static Future<String?> getUserId() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(_userIdKey);
//   }

//   // Remove user ID (e.g., during logout)
//   static Future<void> removeUserId() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_userIdKey);
//   }

//   // save user has registered to shared preferences
//   static Future<void> setHasRegistered() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('has_registered', true);
//   }

//   // get user has registered from shared preferences
//   static Future<bool?> getHasRegistered() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getBool('has_registered');
//   }

//   // remove user has registered from shared preferences
//   static Future<void> removeHasRegistered() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('has_registered');
//   }

//   // save user has logged in so no need to show login screen
//   static Future<void> setHasLoggedIn() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('has_logged_in', true);
//   }

//   // get user has logged in from shared preferences
//   static Future<bool?> getHasLoggedIn() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getBool('has_logged_in');
//   }

//   // remove user has logged in from shared preferences
//   static Future<void> removeHasLoggedIn() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('has_logged_in');
//   }

//   // save user display name to shared preferences

//   static Future<void> setDisplayName(String displayName) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('display_name', displayName);
//   }

//   // get user display name from shared preferences
//   static Future<String?> getDisplayName() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('display_name');
//   }

//   // remove user display name from shared preferences
//   static Future<void> removeDisplayName() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('display_name');
//   }
// }

import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:xm_frontend/data/models/user_pref_model.dart';

class UserPreferences {
  static const String _userKey = "user_data";

  // Save the user object
  static Future<void> saveUser(UserPrefModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    await prefs.setString(_userKey, userJson);
  }

  // Retrieve the user object
  static Future<UserPrefModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);

    if (userJson == null) return null; // No user found

    return UserPrefModel.fromJson(jsonDecode(userJson));
  }

  // Update a specific field in the user object
  static Future<void> updateUserField(String key, dynamic value) async {
    UserPrefModel? user = await getUser();
    if (user == null) return; // No user data available

    // Convert to Map
    Map<String, dynamic> userMap = user.toJson();

    // Update only the specific field
    userMap[key] = value;

    debugPrint('Updated user field: $key to $value');

    // Save the updated user object
    await saveUser(UserPrefModel.fromJson(userMap));
  }

  // Get push notification preference
  static Future<bool> getPushNotificationsEnabled() async {
    UserPrefModel? user = await getUser();

    debugPrint('Push notifications enabled: ${user?.toJson()}');

    return user?.isPushNotificationsEnabled ?? false;
  }

  //  Set push notification preference
  static Future<void> setPushNotificationsEnabled(bool isEnabled) async {
    await updateUserField('is_push_notifications_enabled', isEnabled);
  }

  //  Get email notifications preference
  static Future<bool> getEmailNotificationsEnabled() async {
    UserPrefModel? user = await getUser();
    return user?.isEmailNotificationsEnabled ?? false;
  }

  // Set mail notificationss preference
  static Future<void> setEmailNotificationsEnabled(bool isEnabled) async {
    await updateUserField('is_email_notifications_enabled', isEnabled);
  }

  // Check if a user is logged in
  static Future<bool> isLoggedIn() async {
    final user = await getUser();
    return user?.hasLoggedIn ?? false;
  }

  // Check if a user has registered
  static Future<bool> hasRegistered() async {
    final user = await getUser();
    return user?.hasRegistered ?? false;
  }

  static Future<bool> isAutoLogIn() async {
    final user = await getUser();
    return user?.isAutoLogin ?? false;
  }

  // get user id
  static Future<String?> getUserId() async {
    final user = await getUser();
    return user?.id;
  }

  // Remove user data (Logout)
  static Future<void> removeUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}
