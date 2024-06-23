import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      // Обработка конкретных ошибок (опционально)
      return null; // Обработка других ошибок
    } catch (e) {
      print(e);
      return null; // Обработка других ошибок
    }
  }

  Future<void> signout(BuildContext context) async {
    await auth.signOut();
    Navigator.pushReplacementNamed(context, '/auth');
  }
}
