import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_diplom/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  void initState() {
    super.initState();
    // Добавьте эту строку в initState()
    FirebaseAuth.instance.setSettings(appVerificationDisabledForTesting: true);
  }

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      final userCredential = await AuthService.signInWithEmailAndPassword(
          _emailController.text, _passwordController.text);
      if (userCredential != null) {
        context.go('/mainScreen'); // Assuming proper route configuration
      } else {
        setState(() {
          _errorMessage = "Неверный логин или пароль"; // Example error message
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Вход'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Пожалуйста, введите email.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Пароль'),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Пожалуйста, введите пароль.';
                  }
                  return null;
                },
              ),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ElevatedButton(
                onPressed: _signIn,
                child: Text('Войти'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
