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
      textStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
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

  final List<String> _palabrasNegativas = ['odio', 'triste', 'malo', 'horrible', 'feo'];
  final List<String> _palabrasPositivas = ['bueno', 'feliz', 'excelente', 'genial'];

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
      appBar: AppBar(
        title: Text('Confianza: ${(_confidence * 100.0).toStringAsFixed(1)}%'),
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
        child: Container(
          color: _backgroundColor,
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Prompt LLM:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                widget.prompt,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 24),
              TextHighlight(
                text: _text,
                words: _highlights,
                textStyle: const TextStyle(
                  fontSize: 32.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              if (_isProcessing)
                const Center(child: CircularProgressIndicator()),
              if (_llmResponse != null) ...[
                const SizedBox(height: 24),
                const Text(
                  'Respuesta del asistente:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Card(
                  color: Colors.blue[50],
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(_llmResponse!),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _text != 'Presiona el botón y comienza a hablar' && !_isProcessing
                    ? () => _enviarTextoAlLLM(_text)
                    : null,
                child: const Text('Enviar a LLM'),
              ),
            ],
          ),
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
              "Responde brevemente maximo 2 oraciones, no uses caracteres especiales, no uses emojis, no uses comillas, no uses guiones, no uses puntos ni comas. Responde como un asistente de escritura que ayuda a los usuarios a mejorar sus ideas y textos."
        },
        {"role": "user", "content": prompt}
      ]
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

        // Guardar en historial
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
