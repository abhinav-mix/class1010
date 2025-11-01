import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const String _themeKey = 'app_theme';
  
  // Get the saved theme mode from shared preferences
  static Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString(_themeKey);
    
    if (themeModeString != null) {
      switch (themeModeString) {
        case 'dark':
          return ThemeMode.dark;
        case 'light':
          return ThemeMode.light;
        case 'system':
          return ThemeMode.system;
        default:
          return ThemeMode.dark;
      }
    }
    
    // Default to dark mode
    return ThemeMode.dark;
  }
  
  // Save the theme mode to shared preferences
  static Future<void> saveThemeMode(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = themeMode.toString().split('.').last;
    await prefs.setString(_themeKey, themeModeString);
  }
}