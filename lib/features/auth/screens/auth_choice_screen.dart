import 'package:flutter/material.dart';
import 'package:pluma_ai/features/auth/services/auth_service.dart';

class AuthChoiceScreen extends StatelessWidget {
  const AuthChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _auth = AuthService();

    final primaryColor = const Color(0xFF2C3E50);
    final accentColor = const Color(0xFF18BC9C);

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Elige cómo continuar',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildButton(
                icon: Icons.person_outline,
                label: 'Continuar como invitado',
                color: accentColor,
                onPressed: () async {
                  await _auth.signInAnonymously();
                  Navigator.pushReplacementNamed(context, '/home');
                },
              ),
              const SizedBox(height: 16),
              _buildButton(
                icon: Icons.mail_outline,
                label: 'Iniciar sesión',
                color: accentColor,
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
              ),
              const SizedBox(height: 16),
              _buildButton(
                icon: Icons.person_add_alt_1,
                label: 'Crear cuenta',
                color: accentColor,
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
              ),
              const SizedBox(height: 16),
              _buildButton(
                icon: Icons.g_mobiledata,
                label: 'Continuar con Google',
                color: accentColor,
                onPressed: () async {
                  try {
                    await _auth.signInWithGoogle();
                    Navigator.pushReplacementNamed(context, '/home');
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error con Google: $e'),
                        backgroundColor: Colors.redAccent,
                      ),
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

  Widget _buildButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 24),
      label: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          letterSpacing: 0.8,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
        shadowColor: color.withOpacity(0.6),
        foregroundColor: Colors.white,
      ),
      onPressed: onPressed,
    );
  }
}
