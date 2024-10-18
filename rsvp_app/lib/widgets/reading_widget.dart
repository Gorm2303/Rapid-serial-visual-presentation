import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsvp_app/providers/text_provider.dart';

class ReadingWidget extends StatelessWidget {
  final double maxWidth;

  const ReadingWidget({super.key, required this.maxWidth});

  @override
  Widget build(BuildContext context) {
    final textProvider = Provider.of<TextProvider>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (textProvider.showReadingLines)
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
        if (textProvider.showReadingLines)
          Container(
            height: 2,
            width: maxWidth,
            color: Colors.grey,
            margin: const EdgeInsets.only(top: 10),
          ),
        const SizedBox(height: 16),
        // Display progress bar if enabled
        if (textProvider.getCurrentReadingText.displayProgressBar)
          LinearProgressIndicator(
            value: textProvider.progress,
          ),
        const SizedBox(height: 16),
        // Display time left if enabled
        if (textProvider.getCurrentReadingText.displayTimeLeft)
          Text(
            'Time Left: ${textProvider.formattedRemainingTime}',
            style: const TextStyle(fontSize: 16),
          ),
      ],
    );
  }
}
