import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsvp_app/providers/text_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final textProvider = Provider.of<TextProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
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
              initialWpm: Provider.of<TextProvider>(context, listen: false).wpm,
              initialWordsPerDisplay: Provider.of<TextProvider>(context, listen: false).wordsPerDisplay,
              onWPMChanged: (newWPM) {
                Provider.of<TextProvider>(context, listen: false).setWPM(newWPM);
              },
              onWordsPerDisplayChanged: (newWordsCount) {
                Provider.of<TextProvider>(context, listen: false).setWordsPerDisplay(newWordsCount);
              },
            ),
            // Display the formatted time each chunk is shown for
            Consumer<TextProvider>(
              builder: (context, textProvider, child) {
                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    'Display Time: ${textProvider.displayTime.toStringAsFixed(2)} seconds',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              },
            ),
            // Check button for displaying reading lines
            CheckboxListTile(
              title: const Text('Display Reading Lines'),
              value: textProvider.showReadingLines,  // Get the current value from the provider
              onChanged: (bool? value) {
                if (value != null) {
                  setState(() {
                    textProvider.toggleReadingLines(value);  // Update value in the provider
                  });
                }
              },
            ),

            // Check button for repeating text
            CheckboxListTile(
              title: const Text('Repeat Text'),
              value: textProvider.repeatText,  // Get the current value from the provider
              onChanged: (bool? value) {
                if (value != null) {
                  setState(() {
                    textProvider.toggleRepeatText(value);  // Update value in the provider
                  });
                }
              },
            ),
            // File Upload and Navigation Buttons
            ElevatedButton(
              onPressed: () async {
                String? fileContent = await _fileService.pickTextFile();
                if (fileContent != null) {
                  _textController.text = fileContent;
                  textProvider.setText(fileContent); // Set the text in the provider
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
                Navigator.pushNamed(context, '/reading');
              },
              child: const Text('Go to Reading Screen'),
            ),
          ],
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
