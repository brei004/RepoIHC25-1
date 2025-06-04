import 'package:flutter/material.dart';
import 'package:pluma_ai/features/llm_idea/screens/speech_screen.dart';
import 'features/auth/screens/auth_choice_screen.dart';
import 'features/auth/screens/intro_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/auth/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'features/llm_idea/screens/prompt_setup_screen.dart';
import 'features/llm_idea/screens/input_choice_screen.dart';
import 'features/llm_idea/screens/text_input_screen.dart';
import 'features/llm_idea/screens/speech_screen.dart';
import 'features/history/screens/history_screen.dart';


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
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
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
        '/llm-idea': (_) => const PromptSetupScreen(),
        '/llm-input-choice': (context) {
          final prompt = ModalRoute.of(context)!.settings.arguments as String;
          return InputChoiceScreen(prompt: prompt);
        },
        '/llm-text': (context) {
          final prompt = ModalRoute.of(context)!.settings.arguments as String;
          return TextInputScreen(prompt: prompt);
        },
        '/llm-voice': (context) {
          final prompt = ModalRoute.of(context)!.settings.arguments as String;
          return SpeechScreen(prompt: prompt);
        },
        '/history': (context) => const HistoryScreen(),

      },
    );
  }
}
