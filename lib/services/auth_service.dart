import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
      // Handle specific errors (optional)
      return null; // Handle other errors
    } catch (e) {
      print(e);
      return null; // Handle other errors
    }
  }

  Future<void> signout(BuildContext context) async {
    await auth.signOut();
    context.go('/');
  }
}
