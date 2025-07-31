import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xm_frontend/app/utils/user_preferences.dart';
import 'package:xm_frontend/data/api/services/user_service.dart';
import 'package:xm_frontend/data/models/user_pref_model.dart';

class LanguageService {
  static const String _languageKey = 'selected_language';

  // Save language code to SharedPreferences
  Future<void> saveLanguageCode(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);

    // Check if user is logged in
    UserPrefModel? user = await UserPreferences.getUser();
    if (user != null) {
      // Update the user language code in the database
      final response = await UserService().updateUserLanguageCode(
        int.parse(user.id),
        languageCode,
      );
      debugPrint('Language code updated: $response');
    }
  }

  // Load saved language code from SharedPreferences
  Future<String?> loadLanguageCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey);
  }

  // Get Locale from language code
  Locale getLocale(String languageCode) {
    switch (languageCode) {
      case 'fr':
        return const Locale('fr', 'FR');
      case 'de':
        return const Locale('de', 'DE');
      case 'it':
        return const Locale('it', 'IT');
      case 'en':
        return const Locale('en', 'US');
      default:
        return const Locale('en', 'US');
    }
  }
}
