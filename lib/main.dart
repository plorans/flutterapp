import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const GeekCollectorApp());
}

class GeekCollectorApp extends StatelessWidget {
  const GeekCollectorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GeekCollector',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
