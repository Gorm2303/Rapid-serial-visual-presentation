# Rapid-serial-visual-presentation-app

## File Structure
lib/
│
├── models/
│   ├── reading_text.dart           // Data model for a reading text
│   ├── history_entry.dart          // Model for history entry (title, progress, time left)
│   ├── app_settings.dart           // Model for app-wide settings (WPM, dark mode, etc.)
│
├── providers/
│   ├── text_provider.dart          // Provider for managing the text chunks and WPM
│   ├── history_provider.dart       // Provider for saving and retrieving history entries
│   ├── settings_provider.dart      // Provider for app settings (WPM, dark mode, etc.)
│
├── screens/
│   ├── home_screen.dart            // The main screen of the app (text area, settings, etc.)
│   ├── history_screen.dart         // The screen showing previously read texts
│   ├── reading_screen.dart         // The screen showing text in rapid serial visual format
│   ├── settings_screen.dart        // Settings screen for WPM, display options, etc.
│
├── services/
│   ├── file_service.dart           // Handles file upload and reading text files
│   ├── storage_service.dart        // Handles saving and loading data from device storage
│   ├── summarization_service.dart  // Handles text summarization logic
│   ├── notification_service.dart   // Manages reminders and reading goals notifications
│
├── widgets/
│   ├── text_input_widget.dart      // Widget for text area input
│   ├── wpm_slider_widget.dart      // Widget for WPM slider control
│   ├── history_tile_widget.dart    // Widget for a single history entry in the history tab
│   ├── reading_controls_widget.dart// Widget for start, pause, and repeat controls
│   ├── reading_widget.dart         // Widget to display text chunks during reading
│
├── utils/
│   ├── text_splitter.dart          // Utility to split text into chunks based on WPM and word count
│   ├── sentence_parser.dart        // Utility to detect sentences and natural pauses
│   ├── file_extensions.dart        // Extensions to handle various file formats (txt, md, etc.)
│   ├── time_calculator.dart        // Utility to calculate remaining time, etc.
│
├── main.dart                       // Main entry point of the app
│
├── routes.dart                     // Defines the navigation routes for the app
![image](https://github.com/user-attachments/assets/a44a60c0-ca84-47a6-909c-5358de4cdde7)
