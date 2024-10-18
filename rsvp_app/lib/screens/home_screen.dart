import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsvp_app/models/reading_text.dart';
import 'package:rsvp_app/providers/history_provider.dart';
import 'package:rsvp_app/providers/text_provider.dart';
import 'package:rsvp_app/screens/history_screen.dart';
import 'package:rsvp_app/screens/reading_screen.dart';
import 'package:rsvp_app/widgets/history_tile_widget.dart';
import 'package:rsvp_app/widgets/text_input_widget.dart';
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
  late TextEditingController _titleController;
  final FileService _fileService = FileService();

  double _maxTextWidth = 300;
  int _wpm = 200;
  int _wordsPerDisplay = 3;
  bool _displayReadingLines = false;
  bool _repeatText = false;
  bool _displayProgressBar = false;
  bool _displayTimeLeft = false;
  ReadingText? _editingReadingText;

  @override
  void initState() {
    super.initState();

    _initializeReadingTextState();
  }

  void _initializeReadingTextState() {
    _editingReadingText = widget.readingText;
    _textController = TextEditingController(
      text: _editingReadingText?.fullText ?? '',
    );
    _titleController = TextEditingController(
      text: _editingReadingText?.title ?? '',
    );
    _maxTextWidth = _editingReadingText?.maxTextWidth ?? 300;
    _wpm = _editingReadingText?.wpm ?? 200;
    _wordsPerDisplay = _editingReadingText?.wordsPerDisplay ?? 3;
    _displayReadingLines = _editingReadingText?.displayReadingLines ?? false;
    _repeatText = _editingReadingText?.repeatText ?? false;
    _displayProgressBar = _editingReadingText?.displayProgressBar ?? false;
    _displayTimeLeft = _editingReadingText?.displayTimeLeft ?? false;
  }

  @override
  Widget build(BuildContext context) {
    if (_editingReadingText != null) {
      // When editing a text, hide the TabBar and show only the HomeScreen
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Text')),
        body: _buildAddTextTab(),  // Directly show the add text tab for editing
      );
    }

    // Show TabBar when not editing
    return DefaultTabController(
      length: 3,  // Three tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Reading Speed App'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Add Text'),  // First tab
              Tab(text: 'History'),   // Second tab
              Tab(text: 'Settings'),  // Third tab
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAddTextTab(),   // First tab's content
            _buildHistoryTab(),   // Second tab's content
            _buildSettingsTab(),  // Third tab's content
          ],
        ),
      ),
    );
  }

  // Tab for adding text
  Widget _buildAddTextTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleInput(),
              _buildTextInput(),
              _buildFileUploadButton(),
              const SizedBox(height: 10),
              _buildWPMSlider(),
              _buildDisplaySettings(),
              _buildCheckBoxes(),
              _buildHistoryOrCancelButton(),
              _buildStartOrSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryTab() {
    return const HistoryScreen(); // Replace with the new HistoryScreen class
  }

  // Tab for settings
  Widget _buildSettingsTab() {
    return const Center(
      child: Text('Settings Tab - Add your settings here'),
    );
  }

  // Title input widget
  Widget _buildTitleInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _titleController,
        decoration: const InputDecoration(
          labelText: 'Enter Title (optional)',
          hintText: 'Enter a title for your text',
          contentPadding: EdgeInsets.zero,  // Reduced padding inside the TextField
        ),
      ),
    );
  }

  // Main text input widget
  Widget _buildTextInput() {
    return Flexible(
      fit: FlexFit.loose,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextInputWidget(controller: _textController),
      ),
    );
  }

  // WPM slider widget
  Widget _buildWPMSlider() {
    return WPMSliderWidget(
      initialWpm: _wpm,
      initialWordsPerDisplay: _wordsPerDisplay,
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
    );
  }

  // Display settings widget (progress bar, time left, reading lines)
  Widget _buildDisplaySettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Max Text Width: ${_maxTextWidth.toStringAsFixed(0)}',
          style: const TextStyle(fontSize: 16),
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
      ],
    );
  }


  // Checkboxes for display settings
  Widget _buildCheckBoxes() {
    return Column(
      children: [
        _buildCheckbox('Display Reading Lines', _displayReadingLines, (bool? value) {
          setState(() {
            _displayReadingLines = value ?? false;
          });
        }),
        _buildCheckbox('Repeat Text', _repeatText, (bool? value) {
          setState(() {
            _repeatText = value ?? false;
          });
        }),
        _buildCheckbox('Show Progress Bar', _displayProgressBar, (bool? value) {
          setState(() {
            _displayProgressBar = value ?? false;
          });
        }),
        _buildCheckbox('Show Time Left', _displayTimeLeft, (bool? value) {
          setState(() {
            _displayTimeLeft = value ?? false;
          });
        }),
      ],
    );
  }

  // General checkbox widget
  Widget _buildCheckbox(String title, bool value, Function(bool?) onChanged) {
    return CheckboxListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      visualDensity: VisualDensity.compact,  // Makes the checkbox height smaller
      contentPadding: EdgeInsets.zero,  // Optional: Removes additional padding for even more compactness
    );
  }

  // File upload button
  Widget _buildFileUploadButton() {
    return SizedBox(
      height: 35,  // Set a larger height
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          String? fileContent = await _fileService.pickTextFile();
          if (fileContent != null) {
            _textController.text = fileContent;
          }
        },
      child: const Text('Upload Text'),
      ),
    );
  }

  // History or cancel button
  Widget _buildHistoryOrCancelButton() {
    return _editingReadingText != null ? SizedBox(
      height: 40,  // Set a larger height
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _editingReadingText != null ? _handleCancelChanges : _goToHistoryScreen,
        child: const Text(
          'Cancel',
          style: TextStyle(fontSize: 18),  // Increase text size slightly  
          ),
      ),
    ) : const SizedBox(height: 0);
  }

  void _handleCancelChanges() {
    // Just pop the screen without saving changes
    Navigator.pop(context);
  }

  void _goToHistoryScreen() {
    Navigator.pushNamed(context, '/history');
  }

  // Start reading or save text button with increased size
  Widget _buildStartOrSaveButton() {
    return SizedBox(
      height: 50,  // Set a larger height
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _editingReadingText != null ? _handleSaveText : _handleStartReading,
        child: Text(
          _editingReadingText != null ? 'Save' : 'Start Reading',
          style: const TextStyle(fontSize: 18),  // Increase text size slightly
        ),
      ),
    );
  }

  void _handleSaveText() {
    if (_textController.text.isEmpty) return;

    // Navigate back to the previous screen (e.g., History screen)
    Navigator.pop(context);

    // After navigating, process the text saving logic
    Future.delayed(const Duration(milliseconds: 100), () {
      final title = _titleController.text.isNotEmpty
          ? _titleController.text
          : (_textController.text.length < 60
              ? _textController.text
              : _textController.text.substring(0, 60).replaceAll(RegExp(r'\s+'), ' '));

      // Update the existing ReadingText
      ReadingText updatedReadingText = _editingReadingText!.copyWith(
        title: title,
        fullText: _textController.text,
        wpm: _wpm,
        wordsPerDisplay: _wordsPerDisplay,
        maxTextWidth: _maxTextWidth,
        displayReadingLines: _displayReadingLines,
        repeatText: _repeatText,
        displayProgressBar: _displayProgressBar,
        displayTimeLeft: _displayTimeLeft,
      );

      final textProvider = Provider.of<TextProvider>(context, listen: false);
      textProvider.setReadingText(updatedReadingText);

      _clearFields();  // Reset the UI state
    });
  }


  void _handleStartReading() {
    if (_textController.text.isEmpty) return;

    final title = _titleController.text.isNotEmpty
        ? _titleController.text
        : (_textController.text.length < 60
            ? _textController.text
            : _textController.text.substring(0, 60).replaceAll(RegExp(r'\s+'), ' '));

    ReadingText readingText;
    if (_editingReadingText != null) {
      readingText = _editingReadingText!.copyWith(
        title: title,
        fullText: _textController.text,
        wpm: _wpm,
        wordsPerDisplay: _wordsPerDisplay,
        maxTextWidth: _maxTextWidth,
        displayReadingLines: _displayReadingLines,
        repeatText: _repeatText,
        displayProgressBar: _displayProgressBar,
        displayTimeLeft: _displayTimeLeft,
      );
    } else {
      readingText = ReadingText(
        title: title,
        fullText: _textController.text,
        wpm: _wpm,
        wordsPerDisplay: _wordsPerDisplay,
        maxTextWidth: _maxTextWidth,
        displayReadingLines: _displayReadingLines,
        repeatText: _repeatText,
        displayProgressBar: _displayProgressBar,
        displayTimeLeft: _displayTimeLeft,
      );
    }

    final textProvider = Provider.of<TextProvider>(context, listen: false);
    textProvider.setReadingText(readingText);
    textProvider.startReading();

    _clearFields();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReadingScreen(maxWidth: _maxTextWidth),
      ),
    );
  }

  void _clearFields() {
    setState(() {
      _editingReadingText = null;
    });
    _textController.clear();
    _titleController.clear();
  }

  @override
  void dispose() {
    _textController.dispose();
    _titleController.dispose();
    super.dispose();
  }
}
