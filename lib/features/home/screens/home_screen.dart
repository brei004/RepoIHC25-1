import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String? userName;
  final bool isGuest;

  const HomeScreen({super.key, this.userName, this.isGuest = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pluma AI - Inicio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Por simplicidad: volver a la pantalla inicial de login/intro
              Navigator.pushReplacementNamed(context, '/auth-choice');
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          isGuest
              ? 'Bienvenido Invitado!'
              : 'Bienvenido, ${userName ?? 'Usuario'}',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
