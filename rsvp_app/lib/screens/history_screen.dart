import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsvp_app/providers/history_provider.dart';
import 'package:rsvp_app/providers/text_provider.dart';
import 'package:rsvp_app/screens/home_screen.dart';
import 'package:rsvp_app/screens/reading_screen.dart';
import 'package:rsvp_app/widgets/history_tile_widget.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<HistoryProvider>(context);
    final textProvider = Provider.of<TextProvider>(context, listen: false);

    if (historyProvider.history.isEmpty) {
      return const Center(child: Text('No history available.'));
    }

    return ListView.builder(
      itemCount: historyProvider.history.length,
      itemBuilder: (context, index) {
        final entry = historyProvider.history[index];

        return HistoryTileWidget(
          entry: entry,
          onContinueReading: () {
            // Set the stored ReadingText from the HistoryEntry to the TextProvider
            textProvider.setReadingText(entry.readingText);

            // If progress is 100% or more, restart from the beginning
            if (entry.progress >= 1.0) {
              textProvider.restartFromBeginning();
            } else {
              // Otherwise, set the reading progress to continue from where it left off
              textProvider.setCurrentChunkIndexFromPeriod(entry.progress);
            }

            // Start reading
            textProvider.startReading();

            // Navigate to the ReadingScreen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReadingScreen(maxWidth: entry.readingText.maxTextWidth),
              ),
            );
          },
          onStartFromBeginning: () {
            // Set the stored ReadingText from the HistoryEntry to the TextProvider
            textProvider.setReadingText(entry.readingText);

            // Reset the current chunk index to the beginning
            textProvider.restartFromBeginning(); // Reset the chunk index to 0

            // Start reading from the beginning
            textProvider.startReading();

            // Navigate to ReadingScreen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReadingScreen(maxWidth: entry.readingText.maxTextWidth),
              ),
            );
          },
          onEditText: () {
            // Navigate to HomeScreen with the current ReadingText
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(
                  readingText: entry.readingText, // Pass the ReadingText object to HomeScreen
                ),
              ),
            );
          },
          onDelete: () {
            historyProvider.deleteHistoryEntry(entry);
          },
        );
      },
    );
  }
}
