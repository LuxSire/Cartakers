import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cartakers/app/theme/colors.dart';
import 'package:cartakers/app/theme/typography.dart';
import 'package:get/get.dart';

class ThemeService extends GetxService {
  static ThemeService get instance => Get.find();
  final isDarkMode = false.obs;
  static const String _themePreferenceKey = 'isDarkMode';
  //bool _isDarkMode = false;
   
  //bool get isDarkMode => _isDarkMode;

  ThemeData get lightTheme =>  ThemeData(
    useMaterial3: true,
    tabBarTheme: const TabBarThemeData(
      indicator: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.transparent, // Removes underline globally
          ),
        ),
      ),
    ),

    fontFamily: 'Inter', // Default font for light theme
    brightness: Brightness.light,
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor:  AppColors.blue5001,
    bottomAppBarTheme: const BottomAppBarThemeData(
      color: AppColors.gray50, // Light theme bottom bar color
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.blue50,
      foregroundColor: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Transparent background
        statusBarIconBrightness: Brightness.dark, // Dark icons (Black)
        statusBarBrightness: Brightness.light, // iOS support
      ),
    ),
    cardColor: AppColors.blueGray100,
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
      tertiary: AppColors.blue5001 ,
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

  ThemeData get darkTheme =>  ThemeData(
    tabBarTheme: const TabBarThemeData(
      indicator: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.primaryColor, // Removes underline globally
          ),
        ),
      ),
    ),
    fontFamily: 'Inter', // Default font for dark theme
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryColor,
    cardColor: AppColors.backgroundPrimary,
    scaffoldBackgroundColor: AppColors.indigo900,
    bottomAppBarTheme: const BottomAppBarThemeData(
      color: AppColors.textPrimaryLight, // Dark theme bottom bar color
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.white,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, // Light icons (White)
        statusBarBrightness: Brightness.dark, // iOS support
      ),
    ),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.gray100,
      secondary: AppColors.secondaryColor,
      tertiary: AppColors.actionColor,
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

  debugPrint('Theme toggled before: ${isDarkMode.value}');   
   isDarkMode.value = !isDarkMode.value;
  debugPrint('Theme toggled after: ${isDarkMode.value}');
    
    _saveThemePreference();
  }


  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode.value = prefs.getBool(_themePreferenceKey) ?? true;
  }

  Future<void> _saveThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_themePreferenceKey, isDarkMode.value);
  }
}
