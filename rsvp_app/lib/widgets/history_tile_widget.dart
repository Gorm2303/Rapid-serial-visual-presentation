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
    return ListTile(
      title: Text(entry.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(entry.firstSentence, maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          LinearProgressIndicator(value: entry.progress),
          const SizedBox(height: 4),
          Text('${(entry.progress * 100).toStringAsFixed(4)}% complete'),
          Text('Time Left: ${entry.timeLeft}'),
        ],),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert),
        onPressed: () {
          _showSettingsPopup(context);
        },
      ),
    );
  }

  void _showSettingsPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.play_arrow),
              title: const Text('Continue Reading'),
              onTap: onContinueReading,
            ),
            ListTile(
              leading: const Icon(Icons.restart_alt),
              title: const Text('Start from Beginning'),
              onTap: onStartFromBeginning,
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Text'),
              onTap: onEditText,
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete Text'),
              onTap: onDelete,
            ),
          ],
        );
      },
    );
  }
}
