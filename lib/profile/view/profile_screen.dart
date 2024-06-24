import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_diplom/services/auth_service.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = '';
  String userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      AuthService authService = AuthService();
      DocumentSnapshot userDoc = await authService.getUserData(user.uid);
      if (userDoc.exists) {
        setState(() {
          userName = userDoc['name'];
          userEmail = userDoc['email'];
        });
      } else {
        setState(() {
          userName = 'Имя не найдено';
          userEmail = user.email!;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    return Scaffold(
      appBar: AppBar(
        title: Text('Профиль'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Имя: $userName'),
            Text('Почта: $userEmail'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await auth.signOut(context);
              },
              child: Text('Выход'),
            ),
          ],
        ),
      ),
    );
  }
}
