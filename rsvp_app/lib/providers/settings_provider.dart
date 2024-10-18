import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _displayReadingLines = false;
  bool _repeatText = false;
  bool _showProgressBar = false;
  bool _showTimeLeft = false;

  // Getters
  bool get isDarkMode => _isDarkMode;
  bool get displayReadingLines => _displayReadingLines;
  bool get repeatText => _repeatText;
  bool get showProgressBar => _showProgressBar;
  bool get showTimeLeft => _showTimeLeft;

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

  // Toggle display reading lines and save setting
  void toggleDisplayReadingLines(bool value) {
    _displayReadingLines = value;
    _saveSettings();
    notifyListeners();
  }

  // Toggle repeat text and save setting
  void toggleRepeatText(bool value) {
    _repeatText = value;
    _saveSettings();
    notifyListeners();
  }

  // Toggle show progress bar and save setting
  void toggleShowProgressBar(bool value) {
    _showProgressBar = value;
    _saveSettings();
    notifyListeners();
  }

  // Toggle show time left and save setting
  void toggleShowTimeLeft(bool value) {
    _showTimeLeft = value;
    _saveSettings();
    notifyListeners();
  }

  // Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('dark_mode') ?? false;
    _displayReadingLines = prefs.getBool('display_reading_lines') ?? false;
    _repeatText = prefs.getBool('repeat_text') ?? false;
    _showProgressBar = prefs.getBool('show_progress_bar') ?? false;
    _showTimeLeft = prefs.getBool('show_time_left') ?? false;
    notifyListeners();  // Notify listeners after loading
  }

  // Save settings to SharedPreferences
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', _isDarkMode);
    await prefs.setBool('display_reading_lines', _displayReadingLines);
    await prefs.setBool('repeat_text', _repeatText);
    await prefs.setBool('show_progress_bar', _showProgressBar);
    await prefs.setBool('show_time_left', _showTimeLeft);
  }
}
