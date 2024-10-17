import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsvp_app/providers/history_provider.dart';
import 'package:rsvp_app/providers/text_provider.dart';
import 'package:rsvp_app/screens/reading_screen.dart';
import '../widgets/history_tile_widget.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<HistoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reading History'),
      ),
      body: historyProvider.history.isEmpty
          ? const Center(child: Text('No history available.'))
          : ListView.builder(
        itemCount: historyProvider.history.length,
        itemBuilder: (context, index) {
          final entry = historyProvider.history[index];

          return HistoryTileWidget(
            entry: entry,
            onContinueReading: () {
              final textProvider = Provider.of<TextProvider>(context, listen: false);

              // Set the stored ReadingText from the HistoryEntry to the TextProvider
              textProvider.setReadingText(entry.readingText);

              // Set the reading progress to continue from where it left off
              textProvider.setCurrentChunkIndexFromPeriod(entry.progress);

              // Start reading from where it left off
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
              // Implement your logic to restart from the beginning
            },
            onEditText: () {
              // Implement your logic to edit text
            },
            onDelete: () {
              historyProvider.deleteHistoryEntry(entry);
            },
          );
        },
      ),
    );
  }
}