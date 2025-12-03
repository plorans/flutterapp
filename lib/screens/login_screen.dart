import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'profile_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool rememberMe = false;
  bool isLoading = false;

  Future<void> loginUser() async {
    setState(() => isLoading = true);

    final url = Uri.parse('https://geekcollector.com/wp-json/geekcollector/v1/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _username.text.trim(),
          'password': _password.text.trim(),
        }),
      );

      // Validación por si falla el servidor
      if (response.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error de servidor. Intenta más tarde.")),
        );
        setState(() => isLoading = false);
        return;
      }

      final data = json.decode(response.body);
      print("LOGIN RESPONSE: $data");

      if (data['success'] == true) {
        final user = data['data'];

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProfileScreen(
              userId: user['user_id'] ?? 0,
              username: user['username'] ?? '',
              email: user['email'] ?? '',
              collectorTag: user['collector_tag'] ?? '#G33K',
              bio: user['bio'] ?? '',
              joinDate: user['join_date'] ?? '',
              credit: (user['credit'] ?? 0).toDouble(),
              achievements: user['achievements'] ?? [],
              subscriptions: user['subscriptions'] ?? [],
              avatar: user['avatar'] ?? '',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? "Credenciales incorrectas")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg_login.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Capa oscura
          Container(color: Colors.black.withOpacity(0.5)),

          Center(
            child: SingleChildScrollView(
              child: Container(
                width: 330,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    // Logo
                    Image.asset(
                      "assets/images/logo.png",
                      height: 90,
                    ),
                    const SizedBox(height: 10),

                    const Text(
                      "INICIAR SESIÓN",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Usuario
                    TextField(
                      controller: _username,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "USUARIO O CORREO",
                        labelStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.white10,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Contraseña
                    TextField(
                      controller: _password,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "CONTRASEÑA",
                        labelStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.white10,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Remember me + Recuperar contraseña
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: rememberMe,
                              onChanged: (v) => setState(() => rememberMe = v!),
                              checkColor: Colors.black,
                              activeColor: const Color.fromARGB(255, 255, 94, 0),
                            ),
                            const Text("Recordarme",
                                style: TextStyle(color: Colors.white70)),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            launchUrl(
                                Uri.parse("https://geekcollector.com/my-account/lost-password/"));
                          },
                          child: const Text(
                            "¿Olvidaste tu contraseña?",
                            style: TextStyle(color: Color.fromARGB(255, 255, 94, 0), fontSize: 12),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    // Botón LOGIN
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : loginUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 255, 123, 0),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                "LOGIN",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Botón SIGN UP
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          launchUrl(
                            Uri.parse("https://geekcollector.com/my-account/"),
                            mode: LaunchMode.externalApplication,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.orange, width: 2),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "SIGN UP",
                          style: TextStyle(
                              color: Color.fromARGB(155, 218, 98, 19),
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
