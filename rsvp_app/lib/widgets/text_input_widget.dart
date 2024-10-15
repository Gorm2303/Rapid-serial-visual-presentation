import 'package:flutter/material.dart';

class TextInputWidget extends StatelessWidget {
  final TextEditingController controller;

  const TextInputWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        maxLines: null, // Allows unlimited lines of text
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter or paste your text here',
        ),
      ),
    );
  }
}
