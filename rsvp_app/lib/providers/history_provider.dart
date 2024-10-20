import 'package:flutter/material.dart';
import '../models/history_entry.dart';
import 'package:rsvp_app/services/storage_service.dart';

class HistoryProvider extends ChangeNotifier {
  final List<HistoryEntry> _history = [];
  final StorageService _storageService;

  HistoryProvider(this._storageService);

  // Getter for the history
  List<HistoryEntry> get history => _history;

  // Add or update a history entry
  void addOrUpdateHistoryEntry(HistoryEntry newEntry) {
    final existingEntryIndex = _history.indexWhere(
      (entry) => entry.readingText.textId == newEntry.readingText.textId,
    );

    if (existingEntryIndex != -1) {
      // Update the existing history entry
      _history[existingEntryIndex] = HistoryEntry(
        readingText: newEntry.readingText,  // Replace with the new ReadingText
        progress: newEntry.progress,
        timeLeft: newEntry.timeLeft,
      );
    } else {
      // Add a new history entry
      _history.add(newEntry);
    }

    _saveHistory();  // Save to persistent storage
    notifyListeners();
  }

  // Delete a history entry
  void deleteHistoryEntry(HistoryEntry entry) {
    _history.removeWhere((e) => e.readingText.textId == entry.readingText.textId);
    _saveHistory();  // Save the updated history
    notifyListeners();
  }

  // Clear all history
  void clearHistory() {
    _history.clear();
    _saveHistory();  // Save the cleared history
    notifyListeners();
  }

  // Save history using StorageService
  Future<void> _saveHistory() async {
    await _storageService.saveHistory(_history);  // Use StorageService to save history
  }

  // Load history using StorageService
  Future<void> loadHistory() async {
    final loadedHistory = await _storageService.loadHistory();  // Use StorageService to load history

    _history.clear();
    _history.addAll(loadedHistory);  // Update the in-memory history
    notifyListeners();
  }
}
