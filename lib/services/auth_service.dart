import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithEmail(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> registerWithEmail(String email, String password) {
    return _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signInAnonymously() {
    return _auth.signInAnonymously();
  }

  Future<UserCredential> signInWithGoogle() async {
  final googleUser = await GoogleSignIn().signIn();
  final googleAuth = await googleUser!.authentication;

  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  final userCredential = await _auth.signInWithCredential(credential);
  
  // Asegurarse de que el displayName está actualizado
  if (userCredential.user != null && userCredential.user!.displayName == null) {
    await userCredential.user!.updateDisplayName(googleUser.displayName);
  }
  
  return userCredential;
}

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
