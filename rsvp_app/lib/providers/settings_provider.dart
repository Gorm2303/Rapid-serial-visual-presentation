import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  int _wordsPerMinute = 200;
  int _wordsAtATime = 1;

  // Getters
  bool get isDarkMode => _isDarkMode;
  int get wordsPerMinute => _wordsPerMinute;
  int get wordsAtATime => _wordsAtATime;

  // Toggle Dark Mode
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // Update words per minute
  void updateWordsPerMinute(int wpm) {
    _wordsPerMinute = wpm;
    notifyListeners();
  }

  // Update words displayed at a time
  void updateWordsAtATime(int count) {
    _wordsAtATime = count;
    notifyListeners();
  }
}
