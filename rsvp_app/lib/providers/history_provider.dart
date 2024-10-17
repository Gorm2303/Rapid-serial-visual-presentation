import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/history_entry.dart';  // Import HistoryEntry model

class HistoryProvider extends ChangeNotifier {
  final List<HistoryEntry> _history = [];

  // Getter for the history
  List<HistoryEntry> get history => _history;

  // Add or update a history entry
  void addOrUpdateHistoryEntry(HistoryEntry newEntry) {
    final existingEntryIndex = _history.indexWhere((entry) => entry.title == newEntry.title);

    if (existingEntryIndex != -1) {
      // Update the existing entry
      _history[existingEntryIndex].progress = newEntry.progress;
      _history[existingEntryIndex].timeLeft = newEntry.timeLeft;
      _history[existingEntryIndex].wpm = newEntry.wpm;
    } else {
      // Add a new entry
      _history.add(newEntry);
    }

    _saveHistory(); // Save to shared preferences
    notifyListeners();
  }

  // Delete a history entry
  void deleteHistoryEntry(HistoryEntry entry) {
    _history.removeWhere((e) => e.title == entry.title);
    _saveHistory(); // Save the updated history
    notifyListeners();
  }

  // Save history to SharedPreferences
  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyList = _history.map((entry) => entry.toJson()).toList();
    await prefs.setStringList('reading_history', historyList);
  }

  // Load history from SharedPreferences
  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyList = prefs.getStringList('reading_history') ?? [];

    _history.clear();
    _history.addAll(historyList.map((entryString) => HistoryEntry.fromJson(entryString)));
    notifyListeners();
  }
}
