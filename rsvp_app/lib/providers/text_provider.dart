import 'package:flutter/material.dart';

class TextProvider extends ChangeNotifier {
  String _fullText = '';
  List<String> _textChunks = [];
  int _currentIndex = 0;
  int _wordsPerMinute = 200;  // Default WPM
  int _wordsAtATime = 1;      // Default words shown at a time

  // Getters
  List<String> get textChunks => _textChunks;
  int get currentIndex => _currentIndex;
  int get wordsPerMinute => _wordsPerMinute;
  int get wordsAtATime => _wordsAtATime;

  // Update the text
  void setText(String text) {
    _fullText = text;
    _textChunks = _splitTextIntoChunks();
    _currentIndex = 0;
    notifyListeners();
  }

  // Update WPM and words at a time
  void updateSettings(int wpm, int wordsCount) {
    _wordsPerMinute = wpm;
    _wordsAtATime = wordsCount;
    notifyListeners();
  }

  // Move to the next text chunk
  void nextChunk() {
    if (_currentIndex < _textChunks.length - 1) {
      _currentIndex++;
      notifyListeners();
    }
  }

  // Move to the previous text chunk
  void previousChunk() {
    if (_currentIndex > 0) {
      _currentIndex--;
      notifyListeners();
    }
  }

  // Split the full text into chunks based on wordsAtATime
  List<String> _splitTextIntoChunks() {
    List<String> words = _fullText.split(' ');
    List<String> chunks = [];
    for (int i = 0; i < words.length; i += _wordsAtATime) {
      chunks.add(words.sublist(i, i + _wordsAtATime <= words.length ? i + _wordsAtATime : words.length).join(' '));
    }
    return chunks;
  }
}
