import 'package:flutter/material.dart';
import 'package:rsvp_app/models/history_entry.dart';

class HistoryTileWidget extends StatelessWidget {
  final HistoryEntry entry;

  const HistoryTileWidget({super.key, required this.entry});

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
        ],
      ),
    );
  }
}
