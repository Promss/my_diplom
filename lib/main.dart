import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_diplom/firebase_options.dart';
import 'package:firebase_diplom/auth/view/auth_screens.dart';
import 'package:firebase_diplom/services/auth_service.dart';
import 'package:firebase_diplom/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ThemeData _buildTheme(brightness) {
    var baseTheme = ThemeData(brightness: brightness);
    return baseTheme.copyWith(
      textTheme: GoogleFonts.golosTextTextTheme(baseTheme.textTheme),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            final user = snapshot.data;
            if (user != null) {
              return FutureBuilder(
                future: AuthService().createUserDocumentIfNotExists(user),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return MainScreen();
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              );
            } else {
              return AuthScreen();
            }
          },
        ),
        '/auth': (context) => AuthScreen(),
      },
    );
  }
}
