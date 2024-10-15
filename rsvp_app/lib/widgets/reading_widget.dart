import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsvp_app/providers/text_provider.dart';

class ReadingWidget extends StatelessWidget {
  final double maxWidth;  // Add maxWidth parameter

  const ReadingWidget({super.key, required this.maxWidth});  // Accept maxWidth in the constructor

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
              const SizedBox(height: 20),
              // Optionally show remaining time or controls here
            ],
          ),
        ),
      ),
    );
  }
}
