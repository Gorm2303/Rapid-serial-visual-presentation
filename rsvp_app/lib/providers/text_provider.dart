import 'package:flutter/material.dart';
import 'dart:async';
import '../utils/text_splitter.dart';
import '../utils/time_calculator.dart';
import 'history_provider.dart';
import '../models/history_entry.dart';  // Import HistoryEntry model
import 'package:flutter/scheduler.dart';  // Import SchedulerBinding

class TextProvider extends ChangeNotifier {
  String _fullText = '';
  List<String> _textChunks = [];
  int _currentChunkIndex = 0;
  int _wordsPerDisplay = 3;  // Default words per display
  int _wpm = 200;  // Default Words Per Minute
  bool _showReadingLines = false;  // Option for displaying reading lines
  bool _repeatText = false;  // Option to repeat text when it ends
  Timer? _timer;  // Timer for automatic reading pace
  bool _isReading = false;  // Tracks if reading is ongoing
  final TextSplitter _textSplitter = TextSplitter();

  HistoryProvider _historyProvider;  // Instance of HistoryProvider

  // Constructor to accept HistoryProvider
  TextProvider(this._historyProvider);


  // Add this method to update HistoryProvider without recreating TextProvider
  void updateHistoryProvider(HistoryProvider historyProvider) {
    _historyProvider = historyProvider;
  }

  // Notify listeners after frame is done rendering to avoid locking issues
  void _safeNotifyListeners() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!_isReading) return;  // Ensure reading hasn't stopped
      notifyListeners();
    });
  }

  // Getters
  List<String> get textChunks => _textChunks;
  String get currentChunk => _textChunks.isNotEmpty ? _textChunks[_currentChunkIndex] : '';
  int get currentChunkIndex => _currentChunkIndex;
  int get wordsPerDisplay => _wordsPerDisplay;
  int get wpm => _wpm;
  bool get showReadingLines => _showReadingLines;
  bool get repeatText => _repeatText;
  bool get isReading => _isReading;

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

  // Getter for the formatted remaining time
  String get formattedRemainingTime {
    double remainingSeconds = remainingTime * 60;  // Convert minutes to seconds
    return TimeCalculator.formatTime(remainingSeconds);
  }

  // Set the full text and split into chunks
  void setText(String text) {
    _fullText = text;
    _splitTextIntoChunks();
    _currentChunkIndex = 0;  // Reset to the first chunk
    notifyListeners();  // Notify UI to update
  }

  // Update words per display (restart the timer)
  void setWordsPerDisplay(int wordsCount) {
    _wordsPerDisplay = wordsCount;
    _splitTextIntoChunks();  // Split text into chunks based on the new count
    if (_isReading) {
      _restartTimer();  // Restart the timer with the updated settings
    }
    notifyListeners();
  }

  // Update WPM (restart the timer)
  void setWPM(int newWPM) {
    _wpm = newWPM;
    if (_isReading) {
      _restartTimer();  // Restart the timer with the updated settings
    }
    notifyListeners();
  }

  // Toggle the visibility of reading lines
  void toggleReadingLines(bool value) {
    _showReadingLines = value;
    notifyListeners();
  }

  // Toggle the repeat text option
  void toggleRepeatText(bool value) {
    _repeatText = value;
    notifyListeners();
  }

  // Method to move to the next chunk (with optional repeat logic)
  void nextChunk() {
    if (_currentChunkIndex < _textChunks.length - 1) {
      _currentChunkIndex++;
    } else if (_repeatText) {
      // If repeat is enabled, go back to the first chunk
      _currentChunkIndex = 0;
    } else {
      stopReading();  // Stop if repeat is not enabled and we reach the end
    }
    _updateHistory();  // Update history after moving to the next chunk
    _safeNotifyListeners();;
  }

  // Method to move to the previous chunk
  void previousChunk() {
    if (_currentChunkIndex > 0) {
      _currentChunkIndex--;
    }
    _updateHistory();  // Update history after moving to the previous chunk
    _safeNotifyListeners();;
  }

  // Split the text into chunks based on the words per display
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

  // Timer control based on WPM
  void startReading() {
    stopReading();  // Stop any existing timers

    _isReading = true;

    // Create a function to handle chunk display and timer recreation
    void displayNextChunk() {
      // Dynamically calculate display time for each chunk (in milliseconds)
      int displayTimeInMillis = (TimeCalculator.calculateDisplayTime(_wordsPerDisplay, _wpm) * 1000).toInt();

      // Start a new timer for the next chunk with the calculated duration (in milliseconds)
      _timer = Timer(Duration(milliseconds: displayTimeInMillis), () {
        // Move to the next chunk or stop if finished
        if (_currentChunkIndex < _textChunks.length - 1) {
          _currentChunkIndex++;
          
        } else if (_repeatText) {
          _currentChunkIndex = 0;  // Loop back to the first chunk if repeat is enabled
        } else {
          stopReading();  // Stop the timer if text ends and repeat is not enabled
          return;
        }

        _updateHistory();  // Update history after moving to the next chunk
        _safeNotifyListeners();;  // Update the UI after every chunk

        // Start the timer for the next chunk
        displayNextChunk();
      });

      // Immediately notify the listeners to show the current chunk before waiting for the timer
      _safeNotifyListeners();;
    }

    // Start the first timer and display the first chunk immediately
    displayNextChunk();
  }

  // Restart the timer (called when WPM or words per display changes during reading)
  void _restartTimer() {
    stopReading();  // Stop the current timer
    startReading();  // Start a new timer with the updated settings
  }

  // Stop reading and cancel the timer
  void stopReading() {
    _isReading = false;
    _timer?.cancel();
    _timer = null;
    _safeNotifyListeners();;  // Ensure the UI reflects that reading has stopped
  }

  // Helper method to update history
  void _updateHistory() {
    final firstSentence = _fullText.split('.').first;  // Get the first sentence of the full text
    final progress = (_currentChunkIndex + 1) / _textChunks.length;
    final remainingTime = formattedRemainingTime;  // Get the remaining time

    // Add or update the history entry
    _historyProvider.addOrUpdateHistoryEntry(
      HistoryEntry(
        title: 'Reading Session',  // You can modify this to represent the title of the current text
        firstSentence: firstSentence,
        progress: progress,
        timeLeft: remainingTime,
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer if it exists
    super.dispose();  // Always call super.dispose
  }

}
