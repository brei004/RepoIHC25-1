import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:vibration/vibration.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pluma_ai/features/history/services/history_service.dart';

class SpeechScreen extends StatefulWidget {
  final String prompt;

  const SpeechScreen({super.key, required this.prompt});

  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  final Map<String, HighlightedWord> _highlights = {
    'estudio': HighlightedWord(
      onTap: () => print('estudio'),
      textStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    ),
    'hola': HighlightedWord(
      onTap: () => print('hola'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
    'mejorar': HighlightedWord(
      onTap: () => print('mejorar'),
      textStyle: const TextStyle(color: Colors.green),
    ),
    'podemos': HighlightedWord(
      onTap: () => print('podemos'),
      textStyle: const TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
      ),
    ),
    'bueno': HighlightedWord(
      onTap: () => print('bueno'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
  };

  final List<String> _palabrasNegativas = [
    'odio',
    'triste',
    'malo',
    'horrible',
    'feo',
  ];
  final List<String> _palabrasPositivas = [
    'bueno',
    'feliz',
    'excelente',
    'genial',
  ];

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Presiona el botón y comienza a hablar';
  double _confidence = 1.0;
  Color _backgroundColor = Colors.white;
  bool _isProcessing = false;
  String? _llmResponse;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text('Confianza: ${(_confidence * 100).toStringAsFixed(1)}%'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        duration: const Duration(milliseconds: 2000),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Prompt del Asistente',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              widget.prompt,
              style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
            ),
            const SizedBox(height: 24),
            TextHighlight(
              text: _text,
              words: _highlights,
              textStyle: const TextStyle(
                fontSize: 28,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            if (_isProcessing) const Center(child: CircularProgressIndicator()),
            if (_llmResponse != null) ...[
              Text(
                'Respuesta del Asistente:',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 180,
                  child: SingleChildScrollView(
                    child: Text(
                      _llmResponse!,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed:
                    _text != 'Presiona el botón y comienza a hablar' &&
                        !_isProcessing
                    ? () => _enviarTextoAlLLM(_text)
                    : null,
                icon: const Icon(Icons.send),
                label: const Text('Enviar a LLM'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey[300],
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          localeId: 'es_ES',
          listenFor: const Duration(seconds: 30),
          pauseFor: const Duration(seconds: 5),
          onResult: (val) {
            setState(() {
              _text = val.recognizedWords;
              if (val.hasConfidenceRating && val.confidence > 0) {
                _confidence = val.confidence;
              }

              final lowerText = _text.toLowerCase();

              if (_palabrasNegativas.any((p) => lowerText.contains(p))) {
                _backgroundColor = Colors.red.shade100;
                Vibration.hasVibrator().then((hasVibrator) {
                  if (hasVibrator) Vibration.vibrate(duration: 500);
                });
              } else if (_palabrasPositivas.any((p) => lowerText.contains(p))) {
                _backgroundColor = Colors.green.shade100;
              } else {
                _backgroundColor = Colors.white;
              }
            });
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  Future<void> _enviarTextoAlLLM(String prompt) async {
    setState(() {
      _isProcessing = true;
      _llmResponse = null;
    });

    final url = Uri.parse("https://openrouter.ai/api/v1/chat/completions");
    final headers = {
      'Authorization':
          'Bearer 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',
      'Content-Type': 'application/json',
      'HTTP-Referer': 'https://writevibe.app',
      'X-Title': 'WriteVibeAssistant',
    };
    final body = jsonEncode({
      "model": "deepseek/deepseek-chat:free",
      "messages": [
        {
          "role": "system",
          "content":
              "Responde brevemente maximo 2 oraciones, no uses caracteres especiales, no uses emojis, no uses comillas, no uses guiones, no uses puntos ni comas. Responde como un asistente de escritura que ayuda a los usuarios a mejorar sus ideas y textos.",
        },
        {"role": "user", "content": prompt},
      ],
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        final llmResult = decoded['choices'][0]['message']['content'];
        setState(() {
          _llmResponse = llmResult;
          _isProcessing = false;
        });

        try {
          await HistoryService().savePromptHistory(
            recognizedText: prompt,
            prompt: widget.prompt,
            llmResponse: llmResult,
          );
        } catch (e) {
          debugPrint('No se guardó historial: $e');
        }
      } else {
        setState(() {
          _llmResponse = "Error al generar respuesta:\n${response.body}";
          _isProcessing = false;
        });
        debugPrint("Error API: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        _llmResponse = 'Error al procesar la solicitud: $e';
        _isProcessing = false;
      });
    }
  }
}
