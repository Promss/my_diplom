import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuthService {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> signOut(BuildContext context) async {
    await auth.signOut();
    Navigator.pushReplacementNamed(context, '/auth');
  }

  Future<void> createUserDocumentIfNotExists(User user) async {
    final userDoc = firestore.collection('Users').doc(user.uid);
    final docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      await userDoc.set({
        'email': user.email,
        'name': user.email == 'admin@gmail.com' ? 'Админ' : 'Темурлан',
        'role': user.email == 'admin@gmail.com' ? 'admin' : 'user',
      });
    }
  }

  Future<DocumentSnapshot> getUserData(String userId) async {
    return await firestore.collection('Users').doc(userId).get();
  }
}
