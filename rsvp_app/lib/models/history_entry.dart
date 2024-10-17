import 'dart:convert';

class HistoryEntry {
  final String title;
  final String firstSentence;
  double progress;  // Make progress mutable so it can be updated
  String timeLeft;  // Make timeLeft mutable so it can be updated

  HistoryEntry({
    required this.title,
    required this.firstSentence,
    required this.progress,
    required this.timeLeft,
  });

  // Convert HistoryEntry to a map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'firstSentence': firstSentence,
      'progress': progress,
      'timeLeft': timeLeft,
    };
  }

  // Create a HistoryEntry from a map
  factory HistoryEntry.fromMap(Map<String, dynamic> map) {
    return HistoryEntry(
      title: map['title'],
      firstSentence: map['firstSentence'],
      progress: map['progress'].toDouble(),
      timeLeft: map['timeLeft'],
    );
  }

  // Convert HistoryEntry to a JSON string
  String toJson() => json.encode(toMap());

  // Create a HistoryEntry from a JSON string
  factory HistoryEntry.fromJson(String source) => HistoryEntry.fromMap(json.decode(source));
}
