import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/history');
              },
              child: const Text('Go to History Screen'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/reading');
              },
              child: const Text('Go to Reading Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
