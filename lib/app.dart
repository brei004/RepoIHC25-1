import 'package:flutter/material.dart';
import 'features/auth/screens/auth_choice_screen.dart';
import 'features/auth/screens/intro_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/home/screens/home_screen.dart';

class PlumaApp extends StatelessWidget {
  const PlumaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pluma AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Mejor poner la pantalla inicial de bienvenida o splash si la tienes, si no, la intro
      initialRoute: '/intro', 

      routes: {
        '/intro': (_) => const IntroScreen(),
        '/auth-choice': (_) => const AuthChoiceScreen(),
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        // Agrega aquí la ruta principal o home si la tienes
        '/home': (_) => const HomeScreen(),
      },
    );
  }
}
