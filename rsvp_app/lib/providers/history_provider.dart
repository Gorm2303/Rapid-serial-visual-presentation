import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/history_entry.dart';

class HistoryProvider extends ChangeNotifier {
  final List<HistoryEntry> _history = [];

  // Getter for the history
  List<HistoryEntry> get history => _history;

  // Add or update a history entry
  void addOrUpdateHistoryEntry(HistoryEntry newEntry) {
    final existingEntryIndex = _history.indexWhere((entry) => entry.readingText.title == newEntry.readingText.title);

    if (existingEntryIndex != -1) {
      // Update the existing history entry
      _history[existingEntryIndex].progress = newEntry.progress;
      _history[existingEntryIndex].timeLeft = newEntry.timeLeft;
    } else {
      // Add a new history entry
      _history.add(newEntry);
    }

    _saveHistory();  // Save to SharedPreferences or persistent storage
    notifyListeners();
  }

  // Delete a history entry
  void deleteHistoryEntry(HistoryEntry entry) {
    _history.removeWhere((e) => e.readingText.title == entry.readingText.title);
    _saveHistory();  // Save the updated history
    notifyListeners();
  }

  // Clear all history
  void clearHistory() {
    _history.clear();
    _saveHistory();  // Save the cleared history
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
