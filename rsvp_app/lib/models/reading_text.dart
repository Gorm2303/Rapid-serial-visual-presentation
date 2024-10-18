import 'package:uuid/uuid.dart';  // Add this package to generate unique IDs

class ReadingText {
  final String textId;
  final String title;
  final String fullText;
  final int wpm;
  final int wordsPerDisplay;
  final double maxTextWidth;

  // Constructor where textId is automatically generated
  ReadingText({
    String? textId,  // Optional parameter, auto-generated if not provided
    required this.title,
    required this.fullText,
    required this.wpm,
    required this.wordsPerDisplay,
    required this.maxTextWidth,
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
    };
  }

  // Method to return a new ReadingText object with updated fields
  ReadingText copyWith({
    String? title,
    String? fullText,
    int? wpm,
    int? wordsPerDisplay,
    double? maxTextWidth,
  }) {
    return ReadingText(
      textId: textId,
      title: title ?? this.title,
      fullText: fullText ?? this.fullText,
      wpm: wpm ?? this.wpm,
      wordsPerDisplay: wordsPerDisplay ?? this.wordsPerDisplay,
      maxTextWidth: maxTextWidth ?? this.maxTextWidth,
    );
  }
}
