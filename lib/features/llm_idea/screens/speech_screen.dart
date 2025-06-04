import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:vibration/vibration.dart';

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
              ElevatedButton(
                onPressed: _text != 'Presiona el botón y comienza a hablar' 
                  ? _sendToLLM 
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
                  if (hasVibrator) {
                    Vibration.vibrate(duration: 500);
                  }
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

  Future<void> _sendToLLM() async {
    if (_text.isEmpty || _text == 'Presiona el botón y comienza a hablar') return;
    
    setState(() {
      _isProcessing = true;
      _llmResponse = null;
    });
    
    try {
      // Simulamos la llamada al LLM (implementar según tu necesidad)
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() {
        _llmResponse = 'Respuesta del LLM para: "$_text" usando prompt: "${widget.prompt}"';
        _isProcessing = false;
      });
    } catch (e) {
      setState(() {
        _llmResponse = 'Error al procesar con LLM: $e';
        _isProcessing = false;
      });
    }
  }
}