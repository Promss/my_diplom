import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth auth = FirebaseAuth.instance;

  static Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'credential-already-in-use') {
        // Handle scenario where user might already be signed in
        // (consider refreshing credential or signing out first)
      }
      return null; // Handle other errors
    } catch (e) {
      print(e);
      return null; // Handle other errors
    }
  }
}
