import 'package:flutter/material.dart';
import 'package:rsvp_app/models/reading_text.dart';
import 'package:rsvp_app/providers/settings_provider.dart';
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
  );

  List<String> _textChunks = [];
  int _currentChunkIndex = 0;
  Timer? _timer;
  bool _isReading = false;
  final TextSplitter _textSplitter = TextSplitter();
  late HistoryProvider _historyProvider;
  late SettingsProvider _settingsProvider;

  ReadingText get getCurrentReadingText => _currentReadingText;

  // Constructor
  TextProvider(this._historyProvider, this._settingsProvider);

  // Add a method to update the history provider without recreating TextProvider
  void updateProviders(HistoryProvider historyProvider, SettingsProvider settingsProvider) {
    _historyProvider = historyProvider;
    _settingsProvider = settingsProvider;
    notifyListeners();
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
  bool get isReading => _isReading;
  double get maxTextWidth => _currentReadingText.maxTextWidth;

  // Calculate progress
  double get progress {
    return ((_currentChunkIndex + 1) / _textChunks.length) >= 1 ? 1.0 : ((_currentChunkIndex + 1) / _textChunks.length);
  }

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
  
  void restartFromBeginning() {
    _currentChunkIndex = 0;  // Reset to the first chunk
    notifyListeners();  // Notify the UI to update
  }

  void setCurrentChunkIndexFromPeriod(double progress) {
    // Step 1: Calculate the chunk index based on the progress
    int targetChunkIndex = (progress * _textChunks.length).floor();

    // Step 2: Traverse the text chunks backwards from the target chunk
    for (int i = targetChunkIndex; i >= 0; i--) {
      if (targetChunkIndex - i > 5) {
        // If we have traversed more than 5 chunks, set the index here
        _currentChunkIndex = i;
        break;
      }
      if (_textChunks[i].contains('.')) {
        // If we find a chunk that contains a period, set the index here
        _currentChunkIndex = i;
        break;
      }
    }

    notifyListeners();  // Update the UI
  }

  // Set current ReadingText and split text into chunks
  void setReadingText(ReadingText readingText) {
    // Step 1: Calculate how many words have been read before changing the reading text
    int wordsRead = _calculateWordsRead();

    // Step 2: Set the new reading text
    _currentReadingText = readingText;

    // Step 3: Split the new text into chunks based on the current wordsPerDisplay
    _splitTextIntoChunks();

    // Step 4: Recalculate the chunk index based on the number of words read
    int cumulativeWords = 0;
    for (int i = 0; i < _textChunks.length; i++) {
      cumulativeWords += _textChunks[i].split(RegExp(r'\s+')).length;
      if (cumulativeWords >= wordsRead) {
        _currentChunkIndex = i;
        break;
      }
    }

    // Ensure the new index doesn't exceed the bounds of the new chunks
    if (_currentChunkIndex >= _textChunks.length) {
      _currentChunkIndex = _textChunks.length - 1;
    }

    // Step 5: Update the history with the new reading text and progress
    _updateHistory();  // Update history when setting new reading text
    notifyListeners();  // Notify UI of changes
  }

  // Calculate the number of words read so far based on the current chunk index
  int _calculateWordsRead() {
    int wordsRead = 0;
    for (int i = 0; i < _currentChunkIndex; i++) {
      wordsRead += _textChunks[i].split(RegExp(r'\s+')).length;
    }
    return wordsRead;
  }

  // Split text into chunks
  void _splitTextIntoChunks() {
    _textChunks = _textSplitter.splitTextIntoChunks(_currentReadingText.fullText, _currentReadingText.wordsPerDisplay);
  }

  // Calculate the current word index based on the chunk
  int _calculateCurrentWordIndex() {
    if (_textChunks.isEmpty || _currentChunkIndex >= _textChunks.length) {
      return 0; // Return 0 if no text chunks are available or index exceeds bounds
    }

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
        } else if (_settingsProvider.repeatText) {
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

  // Stop reading and cancel the timer
  void stopReading() {
    _isReading = false;
    _timer?.cancel();
    _timer = null;
    _safeNotifyListeners();
  }

  // Update history entry
  void _updateHistory() {    
    _historyProvider.addOrUpdateHistoryEntry(
      HistoryEntry(
        readingText: _currentReadingText,
        progress: progress,
        timeLeft: formattedRemainingTime,
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();  // Ensure the timer is canceled
    super.dispose();
  }
}
