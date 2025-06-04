import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pluma_ai/features/auth/services/auth_service.dart';

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
      setState(() {
        _userName = user.displayName ?? user.email?.split('@')[0] ?? 'Usuario';
        _userEmail = user.email ?? '';
      });
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
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al cerrar sesión: $e')));
    }
  }

  Widget _buildModuleCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          leading: Icon(icon, size: 40, color: Colors.deepPurple),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pluma AI'),
          automaticallyImplyLeading: false,
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
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView(
                  children: [
                    Text(
                      '👋 Bienvenido/a, $_userName',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (_userEmail.isNotEmpty)
                      Text(
                        _userEmail,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    const SizedBox(height: 24),

                    _buildModuleCard(
                      icon: Icons.mic,
                      title: 'Ideas con voz o texto',
                      subtitle: 'Graba o escribe y mejora tus ideas con IA',
                      onTap: () {
                        Navigator.pushNamed(context, '/llm-idea');
                      },
                    ),
                    _buildModuleCard(
                      icon: Icons.history,
                      title: 'Historial',
                      subtitle: 'Revisa tus creaciones pasadas',
                      onTap: () {
                        final user = FirebaseAuth.instance.currentUser;
                        if (user != null && !user.isAnonymous) {
                          Navigator.pushNamed(context, '/history');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Debes iniciar sesión para acceder al historial.',
                              ),
                            ),
                          );
                        }
                      },
                    ),

                    _buildModuleCard(
                      icon: Icons.show_chart,
                      title: 'Progreso',
                      subtitle: 'Mira cómo has mejorado',
                      onTap: () {
                        final user = FirebaseAuth.instance.currentUser;
                        if (user != null && !user.isAnonymous) {
                          Navigator.pushNamed(context, '/progress');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Debes iniciar sesión para acceder al progreso.',
                              ),
                            ),
                          );
                        }
                      },
                    ),

                    _buildModuleCard(
                      icon: Icons.person,
                      title: 'Perfil',
                      subtitle: 'Edita tu información personal',
                      onTap: () {
                        Navigator.pushNamed(context, '/profile');
                      },
                    ),
                    _buildModuleCard(
                      icon: Icons.settings,
                      title: 'Configuraciones',
                      subtitle: 'Tema, accesibilidad, y más',
                      onTap: () {
                        Navigator.pushNamed(context, '/settings');
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
