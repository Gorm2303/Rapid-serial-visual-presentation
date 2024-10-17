import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsvp_app/models/reading_text.dart';
import 'package:rsvp_app/providers/text_provider.dart';
import 'package:rsvp_app/screens/reading_screen.dart';
import '../widgets/text_input_widget.dart';
import '../services/file_service.dart';
import '../widgets/wpm_slider_widget.dart';

class HomeScreen extends StatefulWidget {
  // Add a ReadingText argument to receive it from other screens (like HistoryScreen)
  final ReadingText? readingText;

  const HomeScreen({super.key, this.readingText});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _textController;  // No longer final, to be updated with the passed text
  final FileService _fileService = FileService();
  double _maxTextWidth = 300;  // Default value for maxWidth

  @override
  void initState() {
    super.initState();
    // Initialize the TextController with the passed reading text or empty string if null
    _textController = TextEditingController(
      text: widget.readingText?.fullText ?? '',
    );

    // Initialize maxTextWidth with passed value or a default one
    _maxTextWidth = widget.readingText?.maxTextWidth ?? 300;
  }

  @override
  Widget build(BuildContext context) {
    final textProvider = Provider.of<TextProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Reading Speed App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextInputWidget(controller: _textController),
                  ),
                ),
                const SizedBox(height: 16),

                WPMSliderWidget(
                  initialWpm: textProvider.wpm,
                  initialWordsPerDisplay: textProvider.wordsPerDisplay,
                  onWPMChanged: (newWPM) {
                    textProvider.setWPM(newWPM);
                  },
                  onWordsPerDisplayChanged: (newWordsCount) {
                    textProvider.setWordsPerDisplay(newWordsCount);
                  },
                ),

                Consumer<TextProvider>(
                  builder: (context, textProvider, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Display Time: ${textProvider.displayTime.toStringAsFixed(2)} seconds',
                          style: const TextStyle(fontSize: 16),
                        ),
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
                  max: 800,
                  divisions: 12,
                  label: _maxTextWidth.toStringAsFixed(0),
                  onChanged: (double value) {
                    setState(() {
                      _maxTextWidth = value;
                    });
                  },
                ),

                CheckboxListTile(
                  title: const Text('Display Reading Lines'),
                  value: textProvider.showReadingLines,
                  onChanged: (bool? value) {
                    if (value != null) {
                      textProvider.toggleReadingLines(value);
                    }
                  },
                ),

                CheckboxListTile(
                  title: const Text('Repeat Text'),
                  value: textProvider.repeatText,
                  onChanged: (bool? value) {
                    if (value != null) {
                      textProvider.toggleRepeatText(value);
                    }
                  },
                ),

                ElevatedButton(
                  onPressed: () async {
                    String? fileContent = await _fileService.pickTextFile();
                    if (fileContent != null) {
                      _textController.text = fileContent;

                      ReadingText readingText = ReadingText(
                        title: 'Uploaded Text',
                        fullText: fileContent,
                        wpm: textProvider.wpm,
                        wordsPerDisplay: textProvider.wordsPerDisplay,
                        maxTextWidth: 300,
                        displayReadingLines: textProvider.showReadingLines,
                        repeatText: textProvider.repeatText,
                      );

                      textProvider.setReadingText(readingText);
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
                      title = _textController.text
                          .substring(0, 60)
                          .replaceAll(RegExp(r'\s+'), ' ');
                    }

                    // Create a new ReadingText object based on the current one using the copyWith method
                    ReadingText currentReadingText = widget.readingText!.copyWith(
                      title: title,
                      fullText: _textController.text,
                      wpm: textProvider.wpm,
                      wordsPerDisplay: textProvider.wordsPerDisplay,
                      maxTextWidth: _maxTextWidth,
                      displayReadingLines: textProvider.showReadingLines,
                      repeatText: textProvider.repeatText,
                    );

                    // Update the TextProvider with the edited ReadingText
                    textProvider.setReadingText(currentReadingText);
                    textProvider.startReading();
                    _textController.clear();  // Clear the text field after starting reading

                    // Navigate to the ReadingScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReadingScreen(maxWidth: _maxTextWidth),
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
