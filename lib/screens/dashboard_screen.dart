import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  final String user;
  final String token;

  const DashboardScreen({super.key, required this.user, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text(
          "GeekCollector",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            Text(
              "Bienvenido:",
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              user,   // ← ← ← AQUÍ SE MUESTRA EL NOMBRE
              style: const TextStyle(
                fontSize: 28,
                color: Colors.orangeAccent,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Tu token:",
              style: TextStyle(color: Colors.white70),
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                token,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 12,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
