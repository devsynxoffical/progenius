import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _storage = GetStorage();
  static const String _themeKey = 'isDarkMode';
  
  var isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadThemePreference();
  }

  void _loadThemePreference() {
    isDarkMode.value = _storage.read(_themeKey) ?? false;
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    _storage.write(_themeKey, isDarkMode.value);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  ThemeMode get themeMode => isDarkMode.value ? ThemeMode.dark : ThemeMode.light;
}

class AppTheme {
  // Light Theme Colors
  static const Color primaryLight = Color(0xff4F2B82);
  static const Color secondaryLight = Color(0xffDC38AA);
  static const Color backgroundLight = Color(0xffFFFFFF);
  static const Color surfaceLight = Color(0xffF5F5F5);
  static const Color textPrimaryLight = Color(0xff000000);
  static const Color textSecondaryLight = Color(0xff6F767E);

  // Dark Theme Colors
  static const Color primaryDark = Color(0xff7C4DFF);
  static const Color secondaryDark = Color(0xffFF4081);
  static const Color backgroundDark = Color(0xff121212);
  static const Color surfaceDark = Color(0xff1E1E1E);
  static const Color textPrimaryDark = Color(0xffFFFFFF);
  static const Color textSecondaryDark = Color(0xffB0B0B0);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryLight,
    scaffoldBackgroundColor: backgroundLight,
    colorScheme: ColorScheme.light(
      primary: primaryLight,
      secondary: secondaryLight,
      surface: surfaceLight,
      background: backgroundLight,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryLight,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: surfaceLight,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryLight,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: textPrimaryLight),
      bodyMedium: TextStyle(color: textSecondaryLight),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryDark,
    scaffoldBackgroundColor: backgroundDark,
    colorScheme: ColorScheme.dark(
      primary: primaryDark,
      secondary: secondaryDark,
      surface: surfaceDark,
      background: backgroundDark,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceDark,
      foregroundColor: textPrimaryDark,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: surfaceDark,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryDark,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: textPrimaryDark),
      bodyMedium: TextStyle(color: textSecondaryDark),
    ),
  );
}
