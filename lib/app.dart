import 'package:flutter/material.dart';
import 'features/auth/screens/auth_choice_screen.dart';
import 'features/auth/screens/intro_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      home: StreamBuilder<User?>(
        stream: AuthService().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          
          if (snapshot.hasData) {
            return const HomeScreen();
          }
          
          return const IntroScreen();
        },
      ),
      routes: {
        '/auth-choice': (_) => const AuthChoiceScreen(),
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/home': (_) => const HomeScreen(),
      },
    );
  }
}