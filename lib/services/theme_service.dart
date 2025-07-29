import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xm_frontend/app/theme/colors.dart';
import 'package:xm_frontend/app/theme/typography.dart';

class ThemeService with ChangeNotifier {
  static const String _themePreferenceKey = 'isDarkMode';
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeData get lightTheme => ThemeData(
    tabBarTheme: const TabBarThemeData(
      indicator: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.transparent, // Removes underline globally
          ),
        ),
      ),
    ),

    fontFamily: 'Lato', // Default font for light theme
    brightness: Brightness.light,
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    bottomAppBarTheme: const BottomAppBarTheme(
      color: AppColors.whiteA700, // Light theme bottom bar color
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Transparent background
        statusBarIconBrightness: Brightness.dark, // Dark icons (Black)
        statusBarBrightness: Brightness.light, // iOS support
      ),
    ),
    cardColor: Colors.white,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.primaryColor),
    ),
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryColor,
      secondary: AppColors.secondaryColor,
    ),
    iconTheme: const IconThemeData(color: AppColors.blueGray90001),
    textTheme: TextTheme(
      displayLarge: AppTypography.headingLarge.copyWith(
        color: AppColors.textPrimaryLight,
      ),
      bodyLarge: AppTypography.bodyText.copyWith(
        color: AppColors.textPrimaryLight,
      ),
      bodyMedium: AppTypography.bodyText.copyWith(
        color: AppColors.textPrimaryLight,
      ),
      bodySmall: AppTypography.bodyText.copyWith(
        color: AppColors.textPrimaryLight,
      ),
      titleLarge: AppTypography.titleLarge.copyWith(
        color: AppColors.textPrimaryLight,
      ),
      titleMedium: AppTypography.titleMedium.copyWith(
        color: AppColors.textPrimaryLight,
      ),
      titleSmall: AppTypography.titleSmall.copyWith(
        color: AppColors.textPrimaryLight,
      ),
    ),
  );

  ThemeData get darkTheme => ThemeData(
    tabBarTheme: const TabBarThemeData(
      indicator: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.transparent, // Removes underline globally
          ),
        ),
      ),
    ),
    fontFamily: 'Lato', // Default font for dark theme
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    bottomAppBarTheme: const BottomAppBarTheme(
      color: AppColors.blueGray90001, // Dark theme bottom bar color
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blueGrey[900],
      foregroundColor: Colors.white,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, // Light icons (White)
        statusBarBrightness: Brightness.dark, // iOS support
      ),
    ),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryColor,
      secondary: AppColors.secondaryColor,
    ),
    iconTheme: const IconThemeData(
      color: AppColors.whiteA700, // Default icon color for dark theme
    ),

    textTheme: TextTheme(
      displayLarge: AppTypography.headingLarge.copyWith(
        color: AppColors.textPrimaryDark,
      ),
      displayMedium: AppTypography.headingMedium.copyWith(
        color: AppColors.textPrimaryDark,
      ),
      bodyLarge: AppTypography.bodyText.copyWith(
        color: AppColors.textPrimaryDark,
      ),
      bodyMedium: AppTypography.bodyText.copyWith(
        color: AppColors.textPrimaryDark,
      ),
      bodySmall: AppTypography.bodyText.copyWith(
        color: AppColors.textPrimaryDark,
      ),
      titleLarge: AppTypography.titleLarge.copyWith(
        color: AppColors.textPrimaryDark,
      ),
      titleMedium: AppTypography.titleMedium.copyWith(
        color: AppColors.textPrimaryDark,
      ),
      titleSmall: AppTypography.titleSmall.copyWith(
        color: AppColors.textPrimaryDark,
      ),
    ),
  );

  ThemeService() {
    _loadThemePreference();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    _saveThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_themePreferenceKey) ?? false;
    notifyListeners();
  }

  Future<void> _saveThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_themePreferenceKey, _isDarkMode);
  }
}
