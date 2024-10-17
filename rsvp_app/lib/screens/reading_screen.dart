import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsvp_app/providers/text_provider.dart';

class ReadingScreen extends StatefulWidget {
  final double maxWidth;

  const ReadingScreen({Key? key, required this.maxWidth}) : super(key: key);

  @override
  _ReadingScreenState createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  TextProvider? _textProvider;  // Store a reference to TextProvider

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get the TextProvider once and store it
    _textProvider = Provider.of<TextProvider>(context, listen: false);
  }

  @override
  void dispose() {
    // Use the stored reference to stop the reading
    _textProvider?.stopReading();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final textProvider = Provider.of<TextProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Reading Screen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display Reading Lines if enabled
              if (textProvider.showReadingLines)
                Container(
                  height: 2,
                  width: widget.maxWidth,
                  color: Colors.grey,
                  margin: const EdgeInsets.only(bottom: 10),
                ),
              // Constrain the width of the text to a max value
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: widget.maxWidth,  // Use the passed maxWidth
                ),
                child: Text(
                  textProvider.currentChunk,
                  style: const TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ),
              // Display Reading Lines if enabled
              if (textProvider.showReadingLines)
                Container(
                  height: 2,
                  width: widget.maxWidth,
                  color: Colors.grey,
                  margin: const EdgeInsets.only(top: 10),
                ),
              // Optionally show remaining time or controls here
            ],
          ),
        ),
      ),
    );
  }
}
