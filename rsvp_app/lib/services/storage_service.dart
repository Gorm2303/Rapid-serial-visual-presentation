import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/history_entry.dart';

class StorageService {
  static const String _historyKey = 'reading_history';

  // Save history to SharedPreferences
  Future<void> saveHistory(List<HistoryEntry> history) async {
    final prefs = await SharedPreferences.getInstance();
    final historyList = history.map((entry) => jsonEncode(entry.toJson())).toList();  // Convert to JSON strings
    await prefs.setStringList(_historyKey, historyList);  // Save list of JSON strings
  }

  // Load history from SharedPreferences
  Future<List<HistoryEntry>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyList = prefs.getStringList(_historyKey) ?? [];

    return historyList.map((entryString) => HistoryEntry.fromJson(jsonDecode(entryString))).toList();
  }

  // Clear stored history
  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}
