import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pluma_ai/features/history/screens/history_detail_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // Evita que usuarios anónimos accedan
    if (user == null || user.isAnonymous) {
      return Scaffold(
        appBar: AppBar(title: const Text('Historial')),
        body: const Center(
          child: Text('Debes iniciar sesión para ver el historial.'),
        ),
      );
    }

    final historyRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('history')
        .orderBy('timestamp', descending: true);

    return Scaffold(
      appBar: AppBar(title: const Text('Historial')),
      body: StreamBuilder<QuerySnapshot>(
        stream: historyRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No hay entradas en tu historial.'),
            );
          }

          final entries = snapshot.data!.docs;

          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final doc = entries[index];
              final data = doc.data() as Map<String, dynamic>;

              final recognizedText = data['recognizedText'] ?? '';
              final prompt = data['prompt'] ?? '';
              final llmResponse = data['llmResponse'] ?? '';
              final timestamp = (data['timestamp'] as Timestamp?)?.toDate();

              return InkWell(
                onTap: () {
                  // Aquí abrimos la pantalla de detalle
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HistoryDetailScreen(data: doc),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (timestamp != null)
                          Text(
                            '🕒 ${_formatDateTime(timestamp)}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        const SizedBox(height: 4),
                        Text(
                          '🗣️ Entrada: $recognizedText',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text('📌 Prompt: $prompt'),
                        const SizedBox(height: 4),
                        Text('🤖 LLM: $llmResponse'),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
