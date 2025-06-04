import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HistoryDetailScreen extends StatelessWidget {
  final DocumentSnapshot data;

  const HistoryDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final docData = data.data() as Map<String, dynamic>? ?? {};

    final input = docData['recognizedText'] ?? '';
    final prompt = docData['prompt'] ?? '';
    final response = docData['llmResponse'] ?? '';
    final timestamp = (docData['timestamp'] as Timestamp?)?.toDate();

    final formattedDate = timestamp != null
        ? DateFormat('dd MMM yyyy - HH:mm').format(timestamp)
        : 'Fecha no disponible';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Historial'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _buildSectionCard(
              icon: Icons.mic,
              title: 'Entrada del usuario',
              content: input,
              context: context,
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              icon: Icons.question_answer,
              title: 'Prompt enviado a la IA',
              content: prompt,
              context: context,
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              icon: Icons.smart_toy,
              title: 'Respuesta generada',
              content: response,
              context: context,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  formattedDate,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required String content,
    required BuildContext context,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SelectableText(
              content.isNotEmpty ? content : 'Sin contenido',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
