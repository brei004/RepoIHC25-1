// lib/features/history/services/history_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> savePromptHistory({
    required String recognizedText,
    required String prompt,
    required String llmResponse,
  }) async {
    final user = _auth.currentUser;
    if (user == null || user.isAnonymous) return; // No guardamos si es invitado

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('history')
        .add({
      'recognizedText': recognizedText,
      'prompt': prompt,
      'llmResponse': llmResponse,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
