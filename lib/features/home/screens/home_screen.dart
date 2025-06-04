import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pluma_ai/services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _auth = AuthService();
  String _userName = 'Invitado';
  String _userEmail = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    
    if (user != null) {
      // Para usuarios registrados con email
      if (user.providerData.any((info) => info.providerId == 'password')) {
        // Verificar si tenemos el nombre en Firestore (si lo guardaste allí)
        // Si no, usar el email como nombre
        setState(() {
          _userName = user.displayName ?? user.email?.split('@')[0] ?? 'Usuario';
          _userEmail = user.email ?? '';
        });
      }
      // Para usuarios de Google
      else if (user.providerData.any((info) => info.providerId == 'google.com')) {
        setState(() {
          _userName = user.displayName ?? 'Usuario Google';
          _userEmail = user.email ?? '';
        });
      }
      // Para invitados
      else if (user.isAnonymous) {
        setState(() {
          _userName = 'Invitado';
          _userEmail = '';
        });
      }
    }

    setState(() => _isLoading = false);
  }

  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context, 
        '/auth-choice', 
        (Route<dynamic> route) => false
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cerrar sesión: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Evita que el botón de retroceso cierre la sesión
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pluma AI'),
          automaticallyImplyLeading: false, // Oculta el botón de retroceso
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _signOut,
              tooltip: 'Cerrar sesión',
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¡Bienvenido/a, $_userName!',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    if (_userEmail.isNotEmpty)
                      Text(
                        _userEmail,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    const SizedBox(height: 32),
                    // Puedes agregar más contenido aquí
                    ElevatedButton(
                      onPressed: () {
                        // Acción adicional
                      },
                      child: const Text('Comenzar'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}