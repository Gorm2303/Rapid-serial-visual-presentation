class TextSplitter {
  // Function to split the text into chunks based on words per display
  List<String> splitTextIntoChunks(String fullText, int wordsPerDisplay) {
    List<String> words = fullText.split(RegExp(r'\s+'));  // Split text into words
    List<String> chunks = [];

    // Loop through the words list and add them to chunks with the specified word count
    for (int i = 0; i < words.length; i += wordsPerDisplay) {
      int end = i + wordsPerDisplay;
      if (end > words.length) end = words.length;  // Handle overflow
      chunks.add(words.sublist(i, end).join(' '));  // Join words into a single chunk
    }

    return chunks;  // Return the list of chunks
  }
}
