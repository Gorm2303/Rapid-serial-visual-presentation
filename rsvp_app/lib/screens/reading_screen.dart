import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsvp_app/providers/text_provider.dart';
import 'package:rsvp_app/widgets/reading_widget.dart';  // Import the new widget

class ReadingScreen extends StatefulWidget {
  final double maxWidth;

  const ReadingScreen({super.key, required this.maxWidth});

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
    return Scaffold(
      appBar: AppBar(title: const Text('Reading Screen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ReadingWidget(
            maxWidth: widget.maxWidth,  // Pass maxWidth
          ),  // Use the updated ReadingWidget that accepts these parameters
        ),
      ),
    );
  }
}
