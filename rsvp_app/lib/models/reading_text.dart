import 'package:uuid/uuid.dart';  // Add this package to generate unique IDs

class ReadingText {
  final String textId;
  final String title;
  final String fullText;
  final int wpm;
  final int wordsPerDisplay;
  final double maxTextWidth;
  final bool displayReadingLines;
  final bool repeatText;
  final bool displayProgressBar;  // New field for progress bar
  final bool displayTimeLeft;  // New field for time left

  // Constructor where textId is automatically generated
  ReadingText({
    String? textId,  // Optional parameter, auto-generated if not provided
    required this.title,
    required this.fullText,
    required this.wpm,
    required this.wordsPerDisplay,
    required this.maxTextWidth,
    required this.displayReadingLines,
    required this.repeatText,
    required this.displayProgressBar,  // New field for progress bar
    required this.displayTimeLeft,  // New field for time left
  }) : textId = textId ?? const Uuid().v4();  // Assigns a new UUID if not provided

  // Convert ReadingText object to a map
  Map<String, dynamic> toMap() {
    return {
      'textId': textId,
      'title': title,
      'fullText': fullText,
      'wpm': wpm,
      'wordsPerDisplay': wordsPerDisplay,
      'maxTextWidth': maxTextWidth,
      'displayReadingLines': displayReadingLines,
      'repeatText': repeatText,
      'displayProgressBar': displayProgressBar,  // New field for progress bar
      'displayTimeLeft': displayTimeLeft,  // New field for time left
    };
  }

  // Create ReadingText from a map
  static ReadingText fromMap(Map<String, dynamic> map) {
    return ReadingText(
      textId: map['textId'],
      title: map['title'],
      fullText: map['fullText'],
      wpm: map['wpm'],
      wordsPerDisplay: map['wordsPerDisplay'],
      maxTextWidth: map['maxTextWidth'],
      displayReadingLines: map['displayReadingLines'] ?? false,  // Provide default value if null
      repeatText: map['repeatText'] ?? false,  // Provide default value if null
      displayProgressBar: map['displayProgressBar'] ?? false,  // Provide default value if null
      displayTimeLeft: map['displayTimeLeft'] ?? false,  // Provide default value if null
    );
  }

  // fromJson and toJson for JSON serialization
  factory ReadingText.fromJson(Map<String, dynamic> json) {
    return ReadingText(
      textId: json['textId'],
      title: json['title'],
      fullText: json['fullText'],
      wpm: json['wpm'],
      wordsPerDisplay: json['wordsPerDisplay'],
      maxTextWidth: json['maxTextWidth'],
      displayReadingLines: json['displayReadingLines'] ?? false,  // Provide default value if null
      repeatText: json['repeatText'] ?? false,  // Provide default value if null
      displayProgressBar: json['displayProgressBar'] ?? false,  // Provide default value if null
      displayTimeLeft: json['displayTimeLeft'] ?? false,  // Provide default value if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'textId': textId,
      'title': title,
      'fullText': fullText,
      'wpm': wpm,
      'wordsPerDisplay': wordsPerDisplay,
      'maxTextWidth': maxTextWidth,
      'displayReadingLines': displayReadingLines,
      'repeatText': repeatText,
      'displayProgressBar': displayProgressBar,  // New field for progress bar
      'displayTimeLeft': displayTimeLeft,  // New field for time left
    };
  }

  // Method to return a new ReadingText object with updated fields
  ReadingText copyWith({
    String? title,
    String? fullText,
    int? wpm,
    int? wordsPerDisplay,
    double? maxTextWidth,
    bool? displayReadingLines,
    bool? repeatText,
    bool? displayProgressBar,  // New field for progress bar
    bool? displayTimeLeft,  // New field for time left
  }) {
    return ReadingText(
      textId: textId,
      title: title ?? this.title,
      fullText: fullText ?? this.fullText,
      wpm: wpm ?? this.wpm,
      wordsPerDisplay: wordsPerDisplay ?? this.wordsPerDisplay,
      maxTextWidth: maxTextWidth ?? this.maxTextWidth,
      displayReadingLines: displayReadingLines ?? this.displayReadingLines,
      repeatText: repeatText ?? this.repeatText,
      displayProgressBar: displayProgressBar ?? this.displayProgressBar,  // New field for progress bar
      displayTimeLeft: displayTimeLeft ?? this.displayTimeLeft,  // New field for time left
    );
  }
}
