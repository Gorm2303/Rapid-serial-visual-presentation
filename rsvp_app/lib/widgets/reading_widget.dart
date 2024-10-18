import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsvp_app/providers/text_provider.dart';
import 'package:rsvp_app/providers/settings_provider.dart';  // Import SettingsProvider

class ReadingWidget extends StatelessWidget {
  final double maxWidth;

  const ReadingWidget({super.key, required this.maxWidth});

  @override
  Widget build(BuildContext context) {
    final textProvider = Provider.of<TextProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);  // Get SettingsProvider

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (settingsProvider.displayReadingLines)  // Use global setting for reading lines
          Container(
            height: 2,
            width: maxWidth,
            color: Colors.grey,
            margin: const EdgeInsets.only(bottom: 10),
          ),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Text(
            textProvider.currentChunk,
            style: const TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
        ),
        if (settingsProvider.displayReadingLines)  // Use global setting for reading lines
          Container(
            height: 2,
            width: maxWidth,
            color: Colors.grey,
            margin: const EdgeInsets.only(top: 10),
          ),
        const SizedBox(height: 16),
        // Display progress bar if enabled in global settings
        if (settingsProvider.showProgressBar) 
          LinearProgressIndicator(
            value: textProvider.progress,
          ),
        const SizedBox(height: 16),
        // Display time left if enabled in global settings
        if (settingsProvider.showTimeLeft) 
          Text(
            'Time Left: ${textProvider.formattedRemainingTime}',
            style: const TextStyle(fontSize: 16),
          ),
      ],
    );
  }
}
