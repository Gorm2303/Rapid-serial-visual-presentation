import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/reading_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String history = '/history';
  static const String reading = '/reading';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case reading:
        return MaterialPageRoute(builder: (_) => const ReadingScreen(maxWidth: 300,));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
