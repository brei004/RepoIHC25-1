import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

    try {
      final response = await http.post(
        Uri.parse("https://openrouter.ai/api/v1/chat/completions"),
        headers: {
          'Authorization':
              'Bearer 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',
          'Content-Type': 'application/json',
          'HTTP-Referer': 'https://writevibe.app',
          'X-Title': 'WriteVibeAssistant',
        },
        body: jsonEncode({
          "model": "deepseek/deepseek-chat:free",
          "messages": [
            {
              "role": "system",
              "content":
                  "Eres un experto en redacción, poesía, discursos y ensayos. Mejora el siguiente texto conservando su estilo y mensaje original, pero hazlo más claro, elegante y emotivo. Solo envía el mensaje referente a eso. Muestrame también los cambios que haces, por qué y el resultado final."
            },
            {
              "role": "user",
              "content": inputText
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        final rawContent = decoded['choices'][0]['message']['content'];
        final cleanContent = _cleanLLMResponse(rawContent);

        setState(() {
          _insight = cleanContent;
          _isLoading = false;
        });
      } else {
        setState(() {
          _insight = "Error al obtener respuesta: ${response.statusCode}";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _insight = "Error al procesar: $e";
        _isLoading = false;
      });
    }
  }

  String _cleanLLMResponse(String raw) {
    // Limpia caracteres tipo #, *, markdown innecesario
    return raw
        .replaceAll(RegExp(r'[#*`>-]'), '')
        .replaceAll(RegExp(r'\n{2,}'), '\n')
        .trim();
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
              'Prompt LLM (interno):',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              'Eres un experto en redacción, poesía, discursos y ensayos...',
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
