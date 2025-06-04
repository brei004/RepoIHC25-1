import 'package:flutter/material.dart';

class InputChoiceScreen extends StatelessWidget {
  final String prompt;

  const InputChoiceScreen({super.key, required this.prompt});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Elegir tipo de entrada'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.input, size: 72, color: theme.colorScheme.primary),
            const SizedBox(height: 24),
            Text(
              '¿Cómo prefieres ingresar tu texto?',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _buildOptionButton(
              context: context,
              icon: Icons.keyboard,
              label: 'ESCRIBIR TEXTO',
              routeName: '/llm-text',
            ),
            const SizedBox(height: 20),
            _buildOptionButton(
              context: context,
              icon: Icons.mic,
              label: 'USAR VOZ',
              routeName: '/llm-voice',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String routeName,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 28),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(label, style: const TextStyle(fontSize: 16)),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          shadowColor: Colors.black38,
        ),
        onPressed: () {
          Navigator.pushNamed(context, routeName, arguments: prompt);
        },
      ),
    );
  }
}
