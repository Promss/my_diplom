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

  bool _isObscure = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  Color _emailBorderColor =
      Color.fromRGBO(103, 80, 165, 1.0); // Initial border color for email field
  Color _passwordBorderColor = Color.fromRGBO(103, 80, 165, 1.0);

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      final userCredential = await AuthService.signInWithEmailAndPassword(
          _emailController.text, _passwordController.text);
      if (userCredential != null) {
        _emailBorderColor = Color.fromRGBO(103, 80, 165, 1.0);
        _passwordBorderColor = Color.fromRGBO(103, 80, 165, 1.0);
        navigateToMainScreen(context); // Separate navigation function
      } else {
        setState(() {
          _emailBorderColor = Colors.red;
          _passwordBorderColor = Colors.red;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Неверный логин или пароль'),
              duration: Duration(seconds: 2),
            ),
          );
        });
      }
    }
  }

  void navigateToMainScreen(BuildContext context) {
    context.go('/mainScreen');
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    double screenWidth = queryData.size.width;
    double screenHeight = queryData.size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SizedBox(
          width: screenWidth / 1.1,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: screenHeight / 5,
                ),
                Center(
                  child: Text(
                    'Авторизация',
                    style: TextStyle(
                        fontSize: screenHeight / 35,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  height: screenHeight / 7,
                ),
                Text(
                  'Укажите e-mail',
                  style: TextStyle(
                      fontSize: screenHeight / 70, fontWeight: FontWeight.w500),
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        vertical: screenHeight / 50,
                        horizontal: screenWidth / 50),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: _emailBorderColor,
                      ),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Пожалуйста, введите email.';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: screenHeight / 25,
                ),
                Text(
                  'Укажите пароль',
                  style: TextStyle(
                      fontSize: screenHeight / 70, fontWeight: FontWeight.w500),
                ),
                TextFormField(
                  obscureText: _isObscure,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        vertical: screenHeight / 50,
                        horizontal: screenWidth / 50),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: _passwordBorderColor,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                    ),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility_off : Icons.visibility,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Пожалуйста, введите пароль.';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: screenHeight / 19,
                ),
                SizedBox(
                  width: double.maxFinite,
                  height: screenHeight / 15,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor:
                            const Color.fromRGBO(103, 80, 165, 1.0)),
                    onPressed: _signIn,
                    child: Text(
                      'Войти',
                      style: TextStyle(
                          color: const Color.fromRGBO(255, 255, 255, 1),
                          fontSize: screenHeight / 50),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
