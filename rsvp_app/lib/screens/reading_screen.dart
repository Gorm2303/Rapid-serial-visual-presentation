import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/text_provider.dart';

class ReadingScreen extends StatelessWidget {
  final double maxWidth;  // Add maxWidth parameter

  const ReadingScreen({super.key, required this.maxWidth});  // Accept maxWidth in the constructor

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
                  width: maxWidth,
                  color: Colors.grey,
                  margin: const EdgeInsets.only(bottom: 10),
                ),
              // Constrain the width of the text to a max value
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: maxWidth,  // Use the passed maxWidth
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
                  width: maxWidth,
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
