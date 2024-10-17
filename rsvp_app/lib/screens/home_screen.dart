import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsvp_app/models/reading_text.dart';
import 'package:rsvp_app/providers/text_provider.dart';
import 'package:rsvp_app/screens/reading_screen.dart';
import '../widgets/text_input_widget.dart';
import '../services/file_service.dart';
import '../widgets/wpm_slider_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _textController = TextEditingController();
  final FileService _fileService = FileService();
  double _maxTextWidth = 300;  // Default value for maxWidth

  @override
  Widget build(BuildContext context) {
    final textProvider = Provider.of<TextProvider>(context);  // Listening for all changes now

    return Scaffold(
      appBar: AppBar(title: const Text('Reading Speed App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(  // Center the entire content
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 1000,  // Use the passed maxWidth
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,  // Align all content to the left
              children: [
                // Use Flexible to ensure the text field only grows as much as needed
                Flexible(
                  fit: FlexFit.loose,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextInputWidget(controller: _textController),
                  ),
                ),
                const SizedBox(height: 16), // Spacing between input and buttons

                // WPM and Words Per Display Sliders with TextField for WPM
                WPMSliderWidget(
                  initialWpm: textProvider.wpm,  // Listening to changes
                  initialWordsPerDisplay: textProvider.wordsPerDisplay,  // Listening to changes
                  onWPMChanged: (newWPM) {
                    textProvider.setWPM(newWPM);  // Update the provider directly
                  },
                  onWordsPerDisplayChanged: (newWordsCount) {
                    textProvider.setWordsPerDisplay(newWordsCount);  // Update the provider directly
                  },
                ),
                
                // Display the formatted time each chunk is shown for
                Consumer<TextProvider>(
                  builder: (context, textProvider, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,  // Align text to the left
                      children: [
                        Text(
                          'Display Time: ${textProvider.displayTime.toStringAsFixed(2)} seconds',
                          style: const TextStyle(fontSize: 16),
                        ),
                        // Add a Slider for maxWidth
                        Text(
                          'Max Text Width: ${_maxTextWidth.toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    );
                  },
                ),
                Slider(
                  value: _maxTextWidth,
                  min: 200,
                  max: 800,  // Adjust the range as necessary
                  divisions: 12,
                  label: _maxTextWidth.toStringAsFixed(0),
                  onChanged: (double value) {
                    setState(() {
                      _maxTextWidth = value;
                    });
                  },
                ),

                // Check button for displaying reading lines
                CheckboxListTile(
                  title: const Text('Display Reading Lines'),
                  value: textProvider.showReadingLines,  // Get the current value from the provider
                  onChanged: (bool? value) {
                    if (value != null) {
                      textProvider.toggleReadingLines(value);  // Directly use provider method
                    }
                  },
                ),

                // Check button for repeating text
                CheckboxListTile(
                  title: const Text('Repeat Text'),
                  value: textProvider.repeatText,  // Get the current value from the provider
                  onChanged: (bool? value) {
                    if (value != null) {
                      textProvider.toggleRepeatText(value);  // Directly use provider method
                    }
                  },
                ),

                // File Upload and Navigation Buttons
                ElevatedButton(
                  onPressed: () async {
                    String? fileContent = await _fileService.pickTextFile();
                    if (fileContent != null) {
                      _textController.text = fileContent;
                      
                      // Create a ReadingText object with default or required settings
                      ReadingText readingText = ReadingText(
                        title: 'Uploaded Text',  // You can modify this to represent the title of the text
                        fullText: fileContent,
                        wpm: textProvider.wpm,  // Get the current WPM from provider or use a default value
                        wordsPerDisplay: textProvider.wordsPerDisplay,  // Use current or default value
                        maxTextWidth: 300,  // Set a default or user-defined max text width
                        displayReadingLines: textProvider.showReadingLines,  // Use the current setting
                        repeatText: textProvider.repeatText,  // Use the current setting
                      );

                      textProvider.setReadingText(readingText); // Pass the ReadingText object
                    }
                  },
                  child: const Text('Upload Text File'),
                ),
                
                const SizedBox(height: 8),

                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/history');
                  },
                  child: const Text('Go to History Screen'),
                ),
                
                const SizedBox(height: 8),
                
                ElevatedButton(
                  onPressed: () {
                    String title;
                    if (_textController.text.length < 60) {
                      title = _textController.text;
                    } else {
                      title = _textController.text.substring(0, 60).replaceAll(RegExp(r'\s+'), ' ');
                    }
                    // Create a ReadingText object from the current text in the controller
                    ReadingText readingText = ReadingText(
                      title: title,  // Replace all whitespace (including newlines) with spaces
                      fullText: _textController.text,
                      wpm: textProvider.wpm,  // Use the current WPM or a default value
                      wordsPerDisplay: textProvider.wordsPerDisplay,  // Use the current words per display
                      maxTextWidth: _maxTextWidth,  // Use the current max text width
                      displayReadingLines: textProvider.showReadingLines,  // Use the current setting
                      repeatText: textProvider.repeatText,  // Use the current setting
                    );

                    textProvider.setReadingText(readingText);  // Pass the ReadingText object
                    textProvider.startReading();  // Start the reading session
                    _textController.text = '';  // Clear the text field

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReadingScreen(maxWidth: _maxTextWidth),  // Pass the maxWidth value
                      ),
                    );
                  },
                  child: const Text('Start Reading'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
