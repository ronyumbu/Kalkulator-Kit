import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends ChangeNotifier {
  static const String _themeModeKey = 'theme_mode';

  // Default values
  String _themeMode = 'auto';

  // Getters
  String get themeMode => _themeMode;

  // Get ThemeMode enum from string
  ThemeMode getThemeMode() {
    switch (_themeMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'auto':
      default:
        return ThemeMode.system;
    }
  }

  // Initialize settings from SharedPreferences
  Future<void> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      _themeMode = prefs.getString(_themeModeKey) ?? 'auto';

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  // Save theme mode
  Future<void> setThemeMode(String mode) async {
    if (mode != _themeMode) {
      _themeMode = mode;
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_themeModeKey, mode);
        notifyListeners();
      } catch (e) {
        debugPrint('Error saving theme mode: $e');
      }
    }
  }

  // Reset all settings to default
  Future<void> resetToDefaults() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      _themeMode = 'auto';

      notifyListeners();
    } catch (e) {
      debugPrint('Error resetting settings: $e');
    }
  }
}
