import 'package:flutter/material.dart';

class TextInputScreen extends StatefulWidget {
  final String prompt;

  const TextInputScreen({super.key, required this.prompt});

  @override
  State<TextInputScreen> createState() => _TextInputScreenState();
}

class _TextInputScreenState extends State<TextInputScreen> {
  final TextEditingController _textController = TextEditingController();
  String? _insight;
  bool _isLoading = false;

  Future<void> _processText() async {
    final inputText = _textController.text.trim();
    if (inputText.isEmpty) return;

    setState(() {
      _isLoading = true;
      _insight = null;
    });

    // Aquí iría la llamada a la API del LLM usando widget.prompt e inputText
    // Por ahora simulamos con un delay y respuesta dummy
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _insight = 'Insight generado para: "$inputText" usando prompt: "${widget.prompt}"';
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Entrada de texto')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Prompt LLM:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              widget.prompt,
              style: const TextStyle(fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _textController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Escribe aquí tu idea o texto...',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _processText,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Generar Insight'),
            ),
            const SizedBox(height: 24),
            if (_insight != null)
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _insight!,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
