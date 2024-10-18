import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsvp_app/services/storage_service.dart';
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
        // SettingsProvider should be initialized first
        ChangeNotifierProvider(create: (_) => SettingsProvider()),

        // Initialize HistoryProvider next
        ChangeNotifierProvider(
          create: (context) {
            final storageService = StorageService();
            final historyProvider = HistoryProvider(storageService);
            historyProvider.loadHistory();  // Load saved history on startup
            return historyProvider;
          },
        ),

        // Use ProxyProvider to ensure TextProvider is passed both HistoryProvider and SettingsProvider
        ChangeNotifierProxyProvider2<HistoryProvider, SettingsProvider, TextProvider>(
          create: (context) => TextProvider(
            Provider.of<HistoryProvider>(context, listen: false),
            Provider.of<SettingsProvider>(context, listen: false),
          ),
          update: (context, historyProvider, settingsProvider, textProvider) {
            textProvider?.updateProviders(historyProvider, settingsProvider); // Update both providers in the existing instance
            return textProvider ?? TextProvider(historyProvider, settingsProvider); // Return the same instance or create one if null
          },
        ),
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
