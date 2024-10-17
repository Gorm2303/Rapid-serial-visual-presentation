import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  int _wpmDefault = 200;  // Default Words Per Minute

  // Getters
  bool get isDarkMode => _isDarkMode;
  int get wpmDefault => _wpmDefault;

  // Constructor to load initial settings
  SettingsProvider() {
    _loadSettings();  // Load settings from persistent storage
  }

  // Toggle dark mode and save setting
  void toggleDarkMode(bool isDark) {
    _isDarkMode = isDark;
    _saveSettings();  // Save settings to persistent storage
    notifyListeners();
  }

  // Set WPM and save setting
  void setWPM(int newWPM) {
    _wpmDefault = newWPM;
    _saveSettings();  // Save WPM to persistent storage
    notifyListeners();
  }

  // Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('dark_mode') ?? false;
    _wpmDefault = prefs.getInt('wpm') ?? 200;  // Default WPM if not set
    notifyListeners();  // Notify listeners after loading
  }

  // Save settings to SharedPreferences
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', _isDarkMode);
    await prefs.setInt('wpm', _wpmDefault);
  }
}
