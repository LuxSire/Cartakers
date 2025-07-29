import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xm_frontend/app/utils/user_preferences.dart';
import 'package:xm_frontend/services/language_service.dart';

class AppController extends GetxController {
  // ── LOCALE / LANGUAGE ─────────────────────────────────────────
  /// The current app locale
  final Rx<Locale> locale = const Locale('de', 'CH').obs;

  /// Shortcut to just the languageCode (e.g. 'en','de'…)
  final RxString languageCode = 'de'.obs;

  final LanguageService _languageService = LanguageService();

  // ── THEME ─────────────────────────────────────────────────────
  /// 'light' | 'dark' | 'system'
  final RxString themeMode = 'light'.obs;

  // ── NOTIFICATIONS ────────────────────────────────────────────
  final RxBool pushNotifications = true.obs;
  final RxBool emailNotifications = false.obs;

  // ── NAVIGATION FLAGS ─────────────────────────────────────────
  /// Example of another reactive flag you already had
  final RxBool navigateToPendingRequests = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSavedLanguage();
    _loadSavedPreferences();
  }

  // ── LOAD LANGUAGE ─────────────────────────────────────────────
  Future<void> _loadSavedLanguage() async {
    final savedCode = await _languageService.loadLanguageCode();
    final code =
        savedCode ?? WidgetsBinding.instance!.window.locale.languageCode;
    final loc = _languageService.getLocale(code);

    locale.value = loc;
    languageCode.value = loc.languageCode;
    Get.updateLocale(loc);
    update();
  }

  /// Call this when user picks a new language
  Future<void> changeLanguage(Locale newLocale) async {
    locale.value = newLocale;
    languageCode.value = newLocale.languageCode;
    await _languageService.saveLanguageCode(newLocale.languageCode);
    Get.updateLocale(newLocale);
    update();
  }

  // ── LOAD THEME & NOTIFICATIONS ────────────────────────────────
  Future<void> _loadSavedPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    // Theme
    themeMode.value = prefs.getString('theme_mode') ?? 'light';
    // Notifications
    pushNotifications.value =
        await UserPreferences.getPushNotificationsEnabled();
    emailNotifications.value =
        await UserPreferences.getEmailNotificationsEnabled();

    // Apply theme immediately
    _applyTheme(themeMode.value);

    update();
  }

  /// Change and persist theme
  Future<void> changeThemeMode(String mode) async {
    themeMode.value = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', mode);
    _applyTheme(mode);
    update();
  }

  void _applyTheme(String mode) {
    if (mode == 'dark') {
      Get.changeThemeMode(ThemeMode.dark);
    } else if (mode == 'light') {
      Get.changeThemeMode(ThemeMode.light);
    } else {
      Get.changeThemeMode(ThemeMode.system);
    }
  }

  // ── PUSH NOTIFICATIONS ────────────────────────────────────────
  Future<void> setPushNotifications(bool on) async {
    pushNotifications.value = on;

    await UserPreferences.setPushNotificationsEnabled(on);
    update();
  }

  // ── EMAIL NOTIFICATIONS ───────────────────────────────────────
  Future<void> setEmailNotifications(bool on) async {
    emailNotifications.value = on;
    await UserPreferences.setEmailNotificationsEnabled(on);
    update();
  }

  // ── EXAMPLE NAVIGATION FLAG ───────────────────────────────────
  void togglePendingRequestsNavigation() {
    navigateToPendingRequests.value = true;
  }

  void resetPendingRequestsNavigation() {
    navigateToPendingRequests.value = false;
  }
}
