import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProgressService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> saveIdea(String idea) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _db.collection('users').doc(uid).collection('ideas').add({
      'text': idea,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<List<String>> fetchIdeas() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return [];

    final snapshot = await _db
        .collection('users')
        .doc(uid)
        .collection('ideas')
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs.map((doc) => doc['text'] as String).toList();
  }
}
