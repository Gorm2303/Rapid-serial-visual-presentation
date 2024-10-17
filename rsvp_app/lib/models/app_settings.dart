import 'dart:convert';

class AppSettings {
  bool isDarkMode;  // Dark mode setting
  int wpmDefault;  // Words per minute setting

  AppSettings({
    required this.isDarkMode,
    required this.wpmDefault,
  });

  // Convert AppSettings to a Map for persistent storage
  Map<String, dynamic> toMap() {
    return {
      'isDarkMode': isDarkMode,
      'wpm': wpmDefault,
    };
  }

  // Create AppSettings from a Map
  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      isDarkMode: map['isDarkMode'],
      wpmDefault: map['wpm'],
    );
  }

  // Convert AppSettings to JSON for persistent storage
  String toJson() => json.encode(toMap());

  // Create AppSettings from a JSON string
  factory AppSettings.fromJson(String source) => AppSettings.fromMap(json.decode(source));
}
