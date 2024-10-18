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
        // Display Reading Lines if enabled
        if (textProvider.showReadingLines)
          Container(
            height: 2,
            width: maxWidth,
            color: Colors.grey,
            margin: const EdgeInsets.only(bottom: 10),
          ),
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
        // Display Reading Lines if enabled
        if (textProvider.showReadingLines)
          Container(
            height: 2,
            width: maxWidth,
            color: Colors.grey,
            margin: const EdgeInsets.only(top: 10),
          ),
        // Optionally add more widgets for time or controls here
      ],
    );
  }
}
