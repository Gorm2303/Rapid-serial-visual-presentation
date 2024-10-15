import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/text_provider.dart';

class ReadingScreen extends StatelessWidget {
  const ReadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textProvider = Provider.of<TextProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Reading Screen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Conditionally show the reading lines
            if (textProvider.showReadingLines)
              const Divider(
                thickness: 2, // Adjust thickness as necessary
                color: Colors.black,
              ),
            
            const SizedBox(height: 5),
            
            // Display the current chunk of text
            Text(
              textProvider.currentChunk,
              style: const TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 5),

            // Conditionally show the reading lines
            if (textProvider.showReadingLines)
              const Divider(
                thickness: 2, // Adjust thickness as necessary
                color: Colors.black,
              ),

            const SizedBox(height: 20),

            // Display the formatted remaining reading time
            Text(
              'Remaining Time: ${textProvider.formattedRemainingTime}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 20),

            // Navigation buttons to move between chunks
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    textProvider.previousChunk();
                  },
                  child: const Text('Previous'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    textProvider.nextChunk();
                  },
                  child: const Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
