import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends ChangeNotifier {
  static const String _themeModeKey = 'theme_mode';
  static const String _vibrationFeedbackKey = 'vibration_feedback';
  static const String _soundEffectsKey = 'sound_effects';

  // Default values
  String _themeMode = 'auto';
  bool _vibrationFeedback = true;
  bool _soundEffects = true;

  // Getters
  String get themeMode => _themeMode;
  bool get vibrationFeedback => _vibrationFeedback;
  bool get soundEffects => _soundEffects;

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
      _vibrationFeedback = prefs.getBool(_vibrationFeedbackKey) ?? true;
      _soundEffects = prefs.getBool(_soundEffectsKey) ?? true;
      
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

  // Save vibration feedback setting
  Future<void> setVibrationFeedback(bool value) async {
    if (value != _vibrationFeedback) {
      _vibrationFeedback = value;
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_vibrationFeedbackKey, value);
        notifyListeners();
      } catch (e) {
        debugPrint('Error saving vibration feedback: $e');
      }
    }
  }

  // Save sound effects setting
  Future<void> setSoundEffects(bool value) async {
    if (value != _soundEffects) {
      _soundEffects = value;
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_soundEffectsKey, value);
        notifyListeners();
      } catch (e) {
        debugPrint('Error saving sound effects: $e');
      }
    }
  }



  // Reset all settings to default
  Future<void> resetToDefaults() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      _themeMode = 'auto';
      _vibrationFeedback = true;
      _soundEffects = true;
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error resetting settings: $e');
    }
  }
}