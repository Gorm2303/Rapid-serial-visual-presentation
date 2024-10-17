import 'package:flutter/material.dart';
import 'package:rsvp_app/models/history_entry.dart';

class HistoryTileWidget extends StatelessWidget {
  final HistoryEntry entry;
  final VoidCallback onContinueReading;
  final VoidCallback onStartFromBeginning;
  final VoidCallback onEditText;
  final VoidCallback onDelete;
  
  const HistoryTileWidget({
    super.key,
    required this.entry,
    required this.onContinueReading,
    required this.onStartFromBeginning,
    required this.onEditText,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Extract first sentence from the fullText of ReadingText
    final firstSentence = entry.readingText.fullText.split('.').first;

    return ListTile(
      title: Text(entry.readingText.title),  // Access the title from ReadingText
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(firstSentence, maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          LinearProgressIndicator(value: entry.progress),
          const SizedBox(height: 4),
          Text('${(entry.progress * 100).toStringAsFixed(2)}% complete'),  // Shorten to 2 decimal places
          Text('Time Left: ${entry.timeLeft}'),  // Display the time left from HistoryEntry
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert),
        onPressed: () {
          _showSettingsPopup(context);
        },
      ),
    );
  }

  // Show the settings popup with options for the history entry
  void _showSettingsPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.play_arrow),
              title: const Text('Continue Reading'),
              onTap: () {
                Navigator.pop(context);  // Close the popup
                onContinueReading();  // Call the continue reading callback
              },
            ),
            ListTile(
              leading: const Icon(Icons.restart_alt),
              title: const Text('Start from Beginning'),
              onTap: () {
                Navigator.pop(context);  // Close the popup
                onStartFromBeginning();  // Call the start from beginning callback
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Text'),
              onTap: () {
                Navigator.pop(context);  // Close the popup
                onEditText();  // Call the edit text callback
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete Text'),
              onTap: () {
                Navigator.pop(context);  // Close the popup
                onDelete();  // Call the delete callback
              },
            ),
          ],
        );
      },
    );
  }
}
