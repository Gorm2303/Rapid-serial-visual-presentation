import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsvp_app/providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildCheckbox(
            'Display Reading Lines',
            settingsProvider.displayReadingLines,
            (value) => settingsProvider.toggleDisplayReadingLines(value!),
          ),
          _buildCheckbox(
            'Repeat Text',
            settingsProvider.repeatText,
            (value) => settingsProvider.toggleRepeatText(value!),
          ),
          _buildCheckbox(
            'Show Progress Bar',
            settingsProvider.showProgressBar,
            (value) => settingsProvider.toggleShowProgressBar(value!),
          ),
          _buildCheckbox(
            'Show Time Left',
            settingsProvider.showTimeLeft,
            (value) => settingsProvider.toggleShowTimeLeft(value!),
          ),
          _buildCheckbox(
            'Dark Mode',
            settingsProvider.isDarkMode,
            (value) => settingsProvider.toggleDarkMode(value!),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckbox(String title, bool value, Function(bool?) onChanged) {
    return CheckboxListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      visualDensity: VisualDensity.compact,
      contentPadding: EdgeInsets.zero,
    );
  }
}
