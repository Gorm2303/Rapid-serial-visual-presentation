import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/text_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/history_provider.dart';
import 'routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Initialize HistoryProvider first
        ChangeNotifierProvider(create: (_) => HistoryProvider()..loadHistory()),

        // Use ProxyProvider to ensure TextProvider is passed HistoryProvider without being recreated unnecessarily
        ChangeNotifierProxyProvider<HistoryProvider, TextProvider>(
          create: (context) => TextProvider(Provider.of<HistoryProvider>(context, listen: false)),
          update: (context, historyProvider, textProvider) {
            textProvider?.updateHistoryProvider(historyProvider); // Update the existing instance
            return textProvider ?? TextProvider(historyProvider); // Return the same instance or create one if null
          },
        ),

        // SettingsProvider
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          return MaterialApp(
            title: 'Rapid Serial Visual Presentation App',
            theme: ThemeData(
              brightness: settingsProvider.isDarkMode ? Brightness.dark : Brightness.light,
            ),
            initialRoute: AppRoutes.home,
            onGenerateRoute: AppRoutes.generateRoute,
          );
        },
      ),
    );
  }
}
