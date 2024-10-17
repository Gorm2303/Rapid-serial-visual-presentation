import 'package:flutter/material.dart';
import 'package:rsvp_app/models/reading_text.dart';
import 'dart:async';
import '../utils/text_splitter.dart';
import '../utils/time_calculator.dart';
import 'history_provider.dart';
import '../models/history_entry.dart';
import 'package:flutter/scheduler.dart';

class TextProvider extends ChangeNotifier {
ReadingText _currentReadingText = ReadingText(
    title: '',
    fullText: '',
    wpm: 450,
    wordsPerDisplay: 6,
    maxTextWidth: 300,
    displayReadingLines: false,
    repeatText: false,
  );

  List<String> _textChunks = [];
  int _currentChunkIndex = 0;
  Timer? _timer;
  bool _isReading = false;
  final TextSplitter _textSplitter = TextSplitter();
  late HistoryProvider _historyProvider;

  // Constructor
  TextProvider(this._historyProvider);

  // Add a method to update the history provider without recreating TextProvider
  void updateHistoryProvider(HistoryProvider historyProvider) {
    _historyProvider = historyProvider;
  }

  // Notify listeners safely after rendering
  void _safeNotifyListeners() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // Getters
  String get currentChunk => _textChunks.isNotEmpty ? _textChunks[_currentChunkIndex] : '';
  int get currentChunkIndex => _currentChunkIndex;
  int get wordsPerDisplay => _currentReadingText.wordsPerDisplay;
  int get wpm => _currentReadingText.wpm;
  bool get repeatText => _currentReadingText.repeatText;
  bool get isReading => _isReading;
  double get maxTextWidth => _currentReadingText.maxTextWidth;
  bool get showReadingLines => _currentReadingText.displayReadingLines;

  // Calculate remaining reading time
  double get remainingTime {
    int totalWords = _currentReadingText.fullText.split(RegExp(r'\s+')).length;
    int currentWordIndex = _calculateCurrentWordIndex();
    return TimeCalculator.calculateRemainingTime(currentWordIndex, totalWords, _currentReadingText.wpm);
  }

  // Calculate time each chunk should be displayed for
  double get displayTime {
    return TimeCalculator.calculateDisplayTime(_currentReadingText.wordsPerDisplay, _currentReadingText.wpm);
  }

  // Formatted remaining time
  String get formattedRemainingTime {
    double remainingSeconds = remainingTime * 60;
    return TimeCalculator.formatTime(remainingSeconds);
  }

  // Set current ReadingText and split text into chunks
  void setReadingText(ReadingText readingText) {
    _currentReadingText = readingText;
    _splitTextIntoChunks();
    _currentChunkIndex = 0;
    notifyListeners();
  }

  // Update words per display
  void setWordsPerDisplay(int wordsCount) {
    _currentReadingText.wordsPerDisplay = wordsCount;
    _splitTextIntoChunks();
    if (_isReading) {
      _restartTimer();
    }
    notifyListeners();
  }

  // Update WPM
  void setWPM(int newWPM) {
    _currentReadingText.wpm = newWPM;
    if (_isReading) {
      _restartTimer();
    }
    notifyListeners();
  }

  // Toggle reading lines
  void toggleReadingLines(bool value) {
    _currentReadingText.displayReadingLines = value;
    notifyListeners();
  }

  // Toggle repeat text
  void toggleRepeatText(bool value) {
    _currentReadingText.repeatText = value;
    notifyListeners();
  }

  // Move to next chunk
  void nextChunk() {
    if (_currentChunkIndex < _textChunks.length - 1) {
      _currentChunkIndex++;
    } else if (_currentReadingText.repeatText) {
      _currentChunkIndex = 0;  // Repeat text from the start
    } else {
      stopReading();
    }
    _updateHistory();
    _safeNotifyListeners();
  }

  // Move to previous chunk
  void previousChunk() {
    if (_currentChunkIndex > 0) {
      _currentChunkIndex--;
    }
    _updateHistory();
    _safeNotifyListeners();
  }

  // Split text into chunks
  void _splitTextIntoChunks() {
    _textChunks = _textSplitter.splitTextIntoChunks(_currentReadingText.fullText, _currentReadingText.wordsPerDisplay);
  }

  // Calculate the current word index based on the chunk
  int _calculateCurrentWordIndex() {
    int wordCount = 0;
    for (int i = 0; i < _currentChunkIndex; i++) {
      wordCount += _textChunks[i].split(RegExp(r'\s+')).length;
    }
    return wordCount;
  }

  // Start reading timer
  void startReading() {
    stopReading();  // Ensure existing timers are stopped

    _isReading = true;

    // Recursively schedule the next chunk
    void displayNextChunk() {
      int displayTimeInMillis = (TimeCalculator.calculateDisplayTime(
        _currentReadingText.wordsPerDisplay, _currentReadingText.wpm) * 1000).toInt();

      _timer = Timer(Duration(milliseconds: displayTimeInMillis), () {
        if (_currentChunkIndex < _textChunks.length - 1) {
          _currentChunkIndex++;
        } else if (_currentReadingText.repeatText) {
          _currentChunkIndex = 0;
        } else {
          stopReading();
          return;
        }
        _updateHistory();
        _safeNotifyListeners();
        displayNextChunk();  // Recursively start the next chunk
      });

      // Notify listeners to display the current chunk
      _safeNotifyListeners();
    }

    displayNextChunk();
  }

  // Restart the timer with updated settings
  void _restartTimer() {
    stopReading();  // Stop any existing timers
    startReading();  // Restart with the updated settings
  }

  // Stop reading and cancel the timer
  void stopReading() {
    _isReading = false;
    _timer?.cancel();
    _timer = null;
    _safeNotifyListeners();
  }

  // Update history entry
  void _updateHistory() {
    final progress = (_currentChunkIndex + 1) / _textChunks.length;
    final remainingTime = formattedRemainingTime;

    _historyProvider.addOrUpdateHistoryEntry(
      HistoryEntry(
        readingText: _currentReadingText,
        progress: progress,
        timeLeft: remainingTime,
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();  // Ensure the timer is canceled
    super.dispose();
  }
}
