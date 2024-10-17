import 'dart:convert';

class ReadingText {
  String title;
  String fullText;
  int wpm;  // Words per minute setting
  int wordsPerDisplay;  // Number of words shown per display
  double maxTextWidth;  // Maximum width for text display
  bool displayReadingLines;  // Whether to display reading lines
  bool repeatText;  // Whether to repeat text after reading is complete

  ReadingText({
    required this.title,
    required this.fullText,
    required this.wpm,
    required this.wordsPerDisplay,
    required this.maxTextWidth,
    required this.displayReadingLines,
    required this.repeatText,
  });

  // Convert ReadingText to a Map for persistent storage
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'fullText': fullText,
      'wpm': wpm,
      'wordsPerDisplay': wordsPerDisplay,
      'maxTextWidth': maxTextWidth,
      'displayReadingLines': displayReadingLines,
      'repeatText': repeatText,
    };
  }

  // Create ReadingText from a Map
  factory ReadingText.fromMap(Map<String, dynamic> map) {
    return ReadingText(
      title: map['title'],
      fullText: map['fullText'],
      wpm: map['wpm'],
      wordsPerDisplay: map['wordsPerDisplay'],
      maxTextWidth: map['maxTextWidth'],
      displayReadingLines: map['displayReadingLines'],
      repeatText: map['repeatText'],
    );
  }

  // Convert ReadingText to JSON for persistent storage
  String toJson() => json.encode(toMap());

  // Create ReadingText from JSON string
  factory ReadingText.fromJson(String source) => ReadingText.fromMap(json.decode(source));
}
