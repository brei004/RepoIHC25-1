import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pluma_ai/features/history/services/history_service.dart';

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

        try {
          await HistoryService().savePromptHistory(
            recognizedText: inputText,
            prompt: widget.prompt,
            llmResponse: cleanContent,
          );
        } catch (e) {
          debugPrint('No se guardó historial: $e');
        }
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editor de Estilo'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Prompt Interno:',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              "Eres un experto en redacción, poesía, discursos y ensayos. Mejora el texto sin alterar su estilo o mensaje original...",
              style: theme.textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _textController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'Escribe aquí tu idea o texto...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _processText,
                icon: _isLoading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.auto_fix_high),
                label: Text(
                  _isLoading ? 'Procesando...' : 'Mejorar Texto',
                  style: const TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_insight != null)
              Expanded(
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: theme.colorScheme.surfaceVariant,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        child: SelectableText(
                          _insight!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
