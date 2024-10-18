import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsvp_app/models/reading_text.dart';
import 'package:rsvp_app/providers/text_provider.dart';
import 'package:rsvp_app/screens/reading_screen.dart';
import '../widgets/text_input_widget.dart';
import '../services/file_service.dart';
import '../widgets/wpm_slider_widget.dart';

class HomeScreen extends StatefulWidget {
  final ReadingText? readingText;

  const HomeScreen({super.key, this.readingText});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _textController;
  final FileService _fileService = FileService();
  
  double _maxTextWidth = 300;  // Default value for maxWidth
  int _wpm = 200;  // Default Words Per Minute
  int _wordsPerDisplay = 3;  // Default Words Per Display
  bool _displayReadingLines = false;  // Default Display Reading Lines
  bool _repeatText = false;  // Default Repeat Text
  bool _displayProgressBar = false;  // Default Show Progress Bar
  bool _displayTimeLeft = false;  // Default Show Time Left Text
  ReadingText? _editingReadingText;  // This will hold the state for readingText

  @override
  void initState() {
    super.initState();

    // Set initial text and maxWidth from widget.readingText or defaults
    _editingReadingText = widget.readingText;  // Manage the mutable readingText state here
    _textController = TextEditingController(
      text: _editingReadingText?.fullText ?? '',
    );
    
    // Initialize settings from readingText or use default values
    _maxTextWidth = _editingReadingText?.maxTextWidth ?? 300;
    _wpm = _editingReadingText?.wpm ?? 200;
    _wordsPerDisplay = _editingReadingText?.wordsPerDisplay ?? 3;
    _displayReadingLines = _editingReadingText?.displayReadingLines ?? false;
    _repeatText = _editingReadingText?.repeatText ?? false;
    _displayProgressBar = widget.readingText?.displayProgressBar ?? false;
    _displayTimeLeft = widget.readingText?.displayTimeLeft ?? false;
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
                  initialWpm: _wpm,  // Use local variable instead of textProvider
                  initialWordsPerDisplay: _wordsPerDisplay,  // Use local variable instead of textProvider
                  onWPMChanged: (newWPM) {
                    setState(() {
                      _wpm = newWPM;
                    });
                  },
                  onWordsPerDisplayChanged: (newWordsCount) {
                    setState(() {
                      _wordsPerDisplay = newWordsCount;
                    });
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
                  value: _displayReadingLines,  // Use local variable
                  onChanged: (bool? value) {
                    if (value != null) {
                      setState(() {
                        _displayReadingLines = value;
                      });
                    }
                  },
                ),

                CheckboxListTile(
                  title: const Text('Repeat Text'),
                  value: _repeatText,  // Use local variable
                  onChanged: (bool? value) {
                    if (value != null) {
                      setState(() {
                        _repeatText = value;
                      });
                    }
                  },
                ),

                // Checkbox for displaying the progress bar
                CheckboxListTile(
                  title: const Text('Show Progress Bar'),
                  value: _displayProgressBar,  // Bind to local variable
                  onChanged: (bool? value) {
                    if (value != null) {
                      setState(() {
                        _displayProgressBar = value;  // Update the local state when checked/unchecked
                      });
                    }
                  },
                ),

                // Checkbox for displaying the time left text
                CheckboxListTile(
                  title: const Text('Show Time Left'),
                  value: _displayTimeLeft,  // Bind to local variable
                  onChanged: (bool? value) {
                    if (value != null) {
                      setState(() {
                        _displayTimeLeft = value;  // Update the local state when checked/unchecked
                      });
                    }
                  },
                ),

                ElevatedButton(
                  onPressed: () async {
                    String? fileContent = await _fileService.pickTextFile();
                    if (fileContent != null) {
                      _textController.text = fileContent;
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
                    if (_textController.text.isEmpty) {
                      return; // Ensure there's text in the controller
                    }

                    String title = '';  // Initialize the title

                    // Check if the user has provided a title in the TextInputWidget
                    if (_editingReadingText != null && _editingReadingText!.title.isNotEmpty) {
                      title = _editingReadingText!.title;  // Use the existing title if editing and a title is provided
                    } else {
                      // Otherwise, derive the title from the full text content if no title is provided
                      if (_textController.text.length < 60) {
                        title = _textController.text;
                      } else {
                        title = _textController.text
                            .substring(0, 60)
                            .replaceAll(RegExp(r'\s+'), ' ');  // Replace multiple spaces with a single space
                      }
                    }

                    ReadingText readingText;

                    // Check if we are editing an existing ReadingText or creating a new one
                    if (_editingReadingText != null) {
                      readingText = _editingReadingText!.copyWith(
                        title: title,
                        fullText: _textController.text,
                        wpm: _wpm,  // Use local variable instead of textProvider
                        wordsPerDisplay: _wordsPerDisplay,  // Use local variable
                        maxTextWidth: _maxTextWidth,
                        displayReadingLines: _displayReadingLines,  // Use local variable
                        repeatText: _repeatText,  // Use local variable
                        displayProgressBar: _displayProgressBar,  // Use local variable
                        displayTimeLeft: _displayTimeLeft,  // Use local variable
                      );
                    } else {
                      // Create a new ReadingText if not editing
                      readingText = ReadingText(
                        title: title,
                        fullText: _textController.text,
                        wpm: _wpm,  // Use local variable instead of textProvider
                        wordsPerDisplay: _wordsPerDisplay,  // Use local variable
                        maxTextWidth: _maxTextWidth,
                        displayReadingLines: _displayReadingLines,  // Use local variable
                        repeatText: _repeatText,  // Use local variable
                        displayProgressBar: _displayProgressBar,  // Use local variable
                        displayTimeLeft: _displayTimeLeft,  // Use local variable
                      );
                    }

                    textProvider.setReadingText(readingText);
                    textProvider.startReading();

                    // Clear the editing state and text field after reading starts
                    setState(() {
                      _editingReadingText = null;
                    });
                    _textController.clear();  // Clear the text field

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
