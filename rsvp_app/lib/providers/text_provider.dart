import 'package:flutter/material.dart';
import '../utils/text_splitter.dart';
import '../utils/time_calculator.dart';

class TextProvider extends ChangeNotifier {
  String _fullText = '';
  List<String> _textChunks = [];
  int _currentChunkIndex = 0;
  int _wordsPerDisplay = 3;  // Default words per display
  int _wpm = 200;  // Default Words Per Minute
  bool _showReadingLines = false;  // Option for displaying reading lines
  bool _repeatText = false;  // Option to repeat text when it ends
  final TextSplitter _textSplitter = TextSplitter();

  // Getters
  List<String> get textChunks => _textChunks;
  String get currentChunk => _textChunks.isNotEmpty ? _textChunks[_currentChunkIndex] : '';
  int get currentChunkIndex => _currentChunkIndex;
  int get wordsPerDisplay => _wordsPerDisplay;
  int get wpm => _wpm;
  bool get showReadingLines => _showReadingLines;
  bool get repeatText => _repeatText;

  // Calculate remaining reading time using TimeCalculator
  double get remainingTime {
    int totalWords = _fullText.split(RegExp(r'\s+')).length;  // Total words in the text
    int currentWordIndex = _calculateCurrentWordIndex();
    return TimeCalculator.calculateRemainingTime(currentWordIndex, totalWords, _wpm);
  }

  // Calculate the time each chunk should be displayed for in seconds
  double get displayTime {
    return TimeCalculator.calculateDisplayTime(_wordsPerDisplay, _wpm);
  }

  // Set the full text and split into chunks
  void setText(String text) {
    _fullText = text;
    _splitTextIntoChunks();
    _currentChunkIndex = 0;  // Reset to the first chunk
    notifyListeners();  // Notify UI to update
  }

  // Update words per display
  void setWordsPerDisplay(int wordsCount) {
    _wordsPerDisplay = wordsCount;
    _splitTextIntoChunks();
    notifyListeners();
  }

  // Update WPM
  void setWPM(int newWPM) {
    _wpm = newWPM;
    notifyListeners();
  }

  void toggleReadingLines(bool value) {
    _showReadingLines = value;
    notifyListeners();
  }

  void toggleRepeatText(bool value) {
    _repeatText = value;
    notifyListeners();
  }

  // Split text into chunks
  void _splitTextIntoChunks() {
    _textChunks = _textSplitter.splitTextIntoChunks(_fullText, _wordsPerDisplay);
  }

  // Calculate the current word index based on the current chunk
  int _calculateCurrentWordIndex() {
    int wordCount = 0;
    for (int i = 0; i < _currentChunkIndex; i++) {
      wordCount += _textChunks[i].split(RegExp(r'\s+')).length;
    }
    return wordCount;
  }

  // Method to move to the next chunk
  void nextChunk() {
    if (_currentChunkIndex < _textChunks.length - 1) {
      _currentChunkIndex++;
    } else if (_repeatText) {
      // If repeat is enabled, go back to the first chunk
      _currentChunkIndex = 0;
    }
    notifyListeners();
  }

  // Method to move to the previous chunk
  void previousChunk() {
    if (_currentChunkIndex > 0) {
      _currentChunkIndex--;
    }
    notifyListeners();
  }

  // Getter for the formatted remaining time
  String get formattedRemainingTime {
    double remainingSeconds = remainingTime * 60;  // Convert minutes to seconds
    return TimeCalculator.formatTime(remainingSeconds);
  }
}
