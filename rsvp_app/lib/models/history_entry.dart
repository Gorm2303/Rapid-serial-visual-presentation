import 'dart:convert';

class HistoryEntry {
  final String title;
  final String firstSentence;
  double progress;  // Mutable for tracking reading progress (e.g., percentage complete)
  String timeLeft;  // Mutable for tracking time left
  int wpm;  // Words per minute for this reading session
  String fullText;  // Full text of the history entry

  HistoryEntry({
    required this.title,
    required this.firstSentence,
    required this.progress,
    required this.timeLeft,
    required this.wpm,
    required this.fullText,
  });

  // Convert HistoryEntry to a map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'firstSentence': firstSentence,
      'progress': progress,
      'timeLeft': timeLeft,
      'wpm': wpm,
      'fullText': fullText,
    };
  }

  // Create a HistoryEntry from a map
  factory HistoryEntry.fromMap(Map<String, dynamic> map) {
    return HistoryEntry(
      title: map['title'],
      firstSentence: map['firstSentence'],
      progress: map['progress'].toDouble(),
      timeLeft: map['timeLeft'],
      wpm: map['wpm'],
      fullText: map['fullText'],
    );
  }

  // Convert HistoryEntry to a JSON string
  String toJson() => json.encode(toMap());

  // Create a HistoryEntry from a JSON string
  factory HistoryEntry.fromJson(String source) => HistoryEntry.fromMap(json.decode(source));
}
