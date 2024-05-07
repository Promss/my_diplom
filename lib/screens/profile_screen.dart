import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_diplom/services/auth_service.dart';

import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await auth.signout(context);
          },
          child: Text('Выход'),
        ),
      ),
    );
  }
}
