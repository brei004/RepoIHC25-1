import 'package:flutter/material.dart';
import 'package:pluma_ai/services/auth_service.dart';

class AuthChoiceScreen extends StatelessWidget {
  const AuthChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _auth = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Elige cómo continuar'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.person_outline),
                label: const Text('Continuar como invitado'),
                onPressed: () async {
                  await _auth.signInAnonymously();
                  Navigator.pushReplacementNamed(context, '/home');
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.mail_outline),
                label: const Text('Iniciar sesión'),
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.person_add_alt_1),
                label: const Text('Crear cuenta'),
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.g_mobiledata),
                label: const Text('Continuar con Google'),
                onPressed: () async {
                  try {
                    await _auth.signInWithGoogle();
                    Navigator.pushReplacementNamed(context, '/home');
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error con Google: $e')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
