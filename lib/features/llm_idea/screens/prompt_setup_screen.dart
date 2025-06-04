import 'package:flutter/material.dart';

class PromptSetupScreen extends StatefulWidget {
  const PromptSetupScreen({super.key});

  @override
  State<PromptSetupScreen> createState() => _PromptSetupScreenState();
}

class _PromptSetupScreenState extends State<PromptSetupScreen> {
  final _controller = TextEditingController();

  void _continue() {
    final prompt = _controller.text.trim();
    if (prompt.isEmpty) return;

    Navigator.pushNamed(
      context,
      '/llm-input-choice',
      arguments: prompt,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurar LLM')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              '¿Cómo quieres que te ayude la IA?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Ej: Ayúdame a mejorar mis ideas de negocio...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _continue,
              child: const Text('Continuar'),
            )
          ],
        ),
      ),
    );
  }
}
