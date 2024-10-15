import 'package:flutter/material.dart';

class HistoryEntry {
  final String title;
  final String firstSentence;
  final double progress;
  final String timeLeft;

  HistoryEntry({
    required this.title,
    required this.firstSentence,
    required this.progress,
    required this.timeLeft,
  });
}

class HistoryProvider extends ChangeNotifier {
  List<HistoryEntry> _history = [];

  // Getter for the history
  List<HistoryEntry> get history => _history;

  // Add a new entry to the history
  void addHistoryEntry(HistoryEntry entry) {
    _history.add(entry);
    notifyListeners();
  }

  // Clear all history
  void clearHistory() {
    _history.clear();
    notifyListeners();
  }
}
