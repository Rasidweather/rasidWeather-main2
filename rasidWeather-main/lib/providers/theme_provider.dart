import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// TODO(MohamedSleem): Theme needs to be refactored

enum AppThemeMode {
  SYSTEM,
  LIGHT,
  DARK,
}

class ThemeModeNotifier with ChangeNotifier {
  AppThemeMode _themeMode = AppThemeMode.LIGHT;

  Future<void> initTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int index = prefs.getInt('themeMode') ?? 0;
    _themeMode = AppThemeMode.values.elementAt(index);
    notifyListeners();
  }

  AppThemeMode getThemeMode() => _themeMode;

  Future<void> setThemeMode(AppThemeMode mode) async {
    _themeMode = mode;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', mode.index);
    notifyListeners();
  }

  ThemeMode mapThemeMode() {
    switch (_themeMode) {
      case AppThemeMode.SYSTEM:
        return ThemeMode.system;
      case AppThemeMode.LIGHT:
        return ThemeMode.light;
      case AppThemeMode.DARK:
        return ThemeMode.dark;
      }
  }
}
