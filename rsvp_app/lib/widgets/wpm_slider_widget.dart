import 'package:flutter/material.dart';

class WPMSliderWidget extends StatefulWidget {
  final int initialWpm;  // Initial words per minute
  final int initialWordsPerDisplay;  // Initial number of words per display
  final ValueChanged<int> onWPMChanged;  // Callback for WPM change
  final ValueChanged<int> onWordsPerDisplayChanged;  // Callback for words per display change

  const WPMSliderWidget({
    super.key,
    required this.initialWpm,
    required this.initialWordsPerDisplay,
    required this.onWPMChanged,
    required this.onWordsPerDisplayChanged,
  });

  @override
  _WPMSliderWidgetState createState() => _WPMSliderWidgetState();
}

class _WPMSliderWidgetState extends State<WPMSliderWidget> {
  late int _wpm;
  late int _wordsPerDisplay;
  late TextEditingController _wpmController;

  @override
  void initState() {
    super.initState();
    _wpm = widget.initialWpm;  // Set initial WPM from widget props
    _wordsPerDisplay = widget.initialWordsPerDisplay;  // Set initial words per display
    _wpmController = TextEditingController(text: _wpm.toString());  // Set up controller with initial WPM value
  }

  @override
  void dispose() {
    _wpmController.dispose();  // Dispose of controller when no longer needed
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant WPMSliderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the initial WPM changes from the parent, update the text controller
    if (widget.initialWpm != oldWidget.initialWpm) {
      setState(() {
        _wpm = widget.initialWpm;
        _wpmController.text = _wpm.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Words Per Minute with Slider and TextField
        Row(
          children: [
            SizedBox(
              width: 80,
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _wpmController,
                decoration: const InputDecoration(
                  labelText: "WPM",
                ),
                onSubmitted: (String value) {
                  final int? newWpm = int.tryParse(value);
                  if (newWpm != null && newWpm >= 50 && newWpm <= 1200) {
                    setState(() {
                      _wpm = newWpm;
                      widget.onWPMChanged(_wpm);  // Notify parent of WPM change
                    });
                  }
                },
              ),
            ),
            Expanded(
              child: Slider(
                value: _wpm.toDouble(),
                min: 50,
                max: 2000,
                divisions: 1950,
                label: _wpm.toString(),
                onChanged: (double value) {
                  setState(() {
                    _wpm = value.toInt();
                    _wpmController.text = _wpm.toString();  // Sync the text field with the slider value
                    widget.onWPMChanged(_wpm);  // Notify parent of WPM change
                  });
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Words Per Display Slider
        Text("Words Per Display: $_wordsPerDisplay", style: const TextStyle(fontSize: 16)),
        Slider(
          value: _wordsPerDisplay.toDouble(),
          min: 1,
          max: 25,
          divisions: 24,
          label: _wordsPerDisplay.toString(),
          onChanged: (double value) {
            setState(() {
              _wordsPerDisplay = value.toInt();
              widget.onWordsPerDisplayChanged(_wordsPerDisplay);  // Notify parent of words per display change
            });
          },
        ),
      ],
    );
  }
}
