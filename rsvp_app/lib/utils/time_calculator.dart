class TimeCalculator {
  // Calculate total reading time in minutes
  static double calculateReadingTime(int totalWords, int wpm) {
    if (wpm == 0) return 0.0;  // Avoid division by zero
    return totalWords / wpm;  // Reading time in minutes
  }

  // Calculate remaining reading time for a specific chunk
  static double calculateRemainingTime(int currentWordIndex, int totalWords, int wpm) {
    if (wpm == 0 || currentWordIndex >= totalWords) return 0.0;
    int remainingWords = totalWords - currentWordIndex;
    return remainingWords / wpm;  // Remaining time in minutes
  }

  // Calculate time for each display based on words per minute and words per display
  static double calculateDisplayTime(int wordsPerDisplay, int wpm) {
    if (wpm == 0) return 0.0;
    return (wordsPerDisplay / wpm) * 60;  // Time in seconds
  }

  // Convert time in seconds to a formatted string (HH:MM:SS)
  static String formatTime(double seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = (seconds % 60).toInt();

    String formattedTime = '';
    if (hours > 0) {
      formattedTime += '$hours:';
    } else {
      formattedTime += '00:';
    }
    formattedTime += '${minutes.toString().padLeft(2, '0')}:';
    formattedTime += secs.toString().padLeft(2, '0');
    
    return formattedTime;
  }
}
