import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_diplom/firebase_options.dart';
import 'package:firebase_diplom/screens/auth_screens.dart';
import 'package:firebase_diplom/screens/employyes_screen.dart';
import 'package:firebase_diplom/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
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
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: _buildTheme(Brightness.light),
      routerConfig: _router,
    );
  }
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: 'auth',
      path: '/',
      builder: ((context, state) => AuthScreen()),
    ),
    GoRoute(
      name: 'MainScreen',
      path: '/mainScreen',
      builder: (BuildContext context, GoRouterState state) {
        return const MainScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          name: 'Employees',
          path: 'employees',
          builder: (BuildContext context, GoRouterState state) {
            return const EmployeesScreen();
          },
        ),
      ],
    ),
  ],
);