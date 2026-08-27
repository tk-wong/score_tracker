import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeController {
  static const _themeModeKey = "THEME_MODE_KEY";

  static Future<ThemeMode> getThemeMode() async {
    final preferences = await SharedPreferences.getInstance();
    int themeModeIndex =
        preferences.getInt(_themeModeKey) ?? ThemeMode.system.index;
    try {
      return ThemeMode.values[themeModeIndex];
    } catch (e) {
      return ThemeMode.system;
    }
  }

  static void setThemeMode(ThemeMode thememode) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt(_themeModeKey, thememode.index);
  }
}
