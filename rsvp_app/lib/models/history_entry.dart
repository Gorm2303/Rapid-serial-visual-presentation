import 'dart:convert';
import 'reading_text.dart';

class HistoryEntry {
  final ReadingText readingText;  // Reference to the ReadingText being read
  double progress;  // Reading progress as a percentage
  String timeLeft;  // Time left for the session

  HistoryEntry({
    required this.readingText,
    required this.progress,
    required this.timeLeft,
  });

  // Convert HistoryEntry to a Map for persistent storage
  Map<String, dynamic> toMap() {
    return {
      'readingText': readingText.toMap(),
      'progress': progress,
      'timeLeft': timeLeft,
    };
  }

  // Create HistoryEntry from a Map
  factory HistoryEntry.fromMap(Map<String, dynamic> map) {
    return HistoryEntry(
      readingText: ReadingText.fromMap(map['readingText']),
      progress: map['progress'].toDouble(),
      timeLeft: map['timeLeft'],
    );
  }

  // Convert HistoryEntry to JSON for persistent storage
  String toJson() => json.encode(toMap());

  // Create HistoryEntry from JSON string
  factory HistoryEntry.fromJson(String source) => HistoryEntry.fromMap(json.decode(source));
}
