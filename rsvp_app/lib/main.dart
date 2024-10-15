import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/text_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/history_provider.dart';
import 'routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TextProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          return MaterialApp(
            title: 'Rapid Serial Visual Presentation App',
            theme: ThemeData(
              brightness: settingsProvider.isDarkMode
                  ? Brightness.dark
                  : Brightness.light,
            ),
            initialRoute: AppRoutes.home,
            onGenerateRoute: AppRoutes.generateRoute,
          );
        },
      ),
    );
  }
}
