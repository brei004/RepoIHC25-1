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

    final primaryColor = const Color(0xFF2C3E50);
    final accentColor = const Color(0xFF18BC9C);
    final cardBackground = Colors.white;

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Detalle del Historial',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
        child: ListView(
          children: [
            _buildSectionCard(
              icon: Icons.mic,
              title: 'Entrada del usuario',
              content: input,
              accentColor: accentColor,
              cardBackground: cardBackground,
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              icon: Icons.question_answer,
              title: 'Prompt enviado a la IA',
              content: prompt,
              accentColor: accentColor,
              cardBackground: cardBackground,
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              icon: Icons.smart_toy,
              title: 'Respuesta generada',
              content: response,
              accentColor: accentColor,
              cardBackground: cardBackground,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.white70),
                const SizedBox(width: 8),
                Text(
                  formattedDate,
                  style: const TextStyle(color: Colors.white70),
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
    required Color accentColor,
    required Color cardBackground,
  }) {
    return Card(
      color: cardBackground,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      shadowColor: accentColor.withOpacity(0.4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 22, color: accentColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    letterSpacing: 0.8,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SelectableText(
              content.isNotEmpty ? content : 'Sin contenido',
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
