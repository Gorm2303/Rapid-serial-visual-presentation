import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsvp_app/providers/history_provider.dart';
import '../widgets/history_tile_widget.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<HistoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reading History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // Clear the history
              historyProvider.clearHistory();
            },
          ),
        ],
      ),
      body: historyProvider.history.isEmpty
          ? const Center(child: Text('No history available.'))
          : ListView.builder(
              itemCount: historyProvider.history.length,
              itemBuilder: (context, index) {
                final entry = historyProvider.history[index];
                return HistoryTileWidget(entry: entry);
              },
            ),
    );
  }
}
