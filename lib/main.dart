import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_diplom/direction/controller/add_direction_controller.dart';
import 'package:firebase_diplom/direction/controller/direction_controller.dart';
import 'package:firebase_diplom/employyes/controller/add_employee_controller.dart';
import 'package:firebase_diplom/employyes/controller/employee_controller.dart';
import 'package:firebase_diplom/firebase_options.dart';
import 'package:firebase_diplom/auth/view/auth_screens.dart';
import 'package:firebase_diplom/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          routerConfig: GoRouter(
            // Set initial location based on user state
            initialLocation: user != null ? '/mainScreen' : '/',
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
                  return MainScreen();
                },
                routes: <RouteBase>[
                  GoRoute(
                    name: 'Employees',
                    path: 'employees',
                    builder: (BuildContext context, GoRouterState state) {
                      return EmployeesController();
                    },
                  ),
                  GoRoute(
                    name: 'Direction',
                    path: 'direction',
                    builder: (BuildContext context, GoRouterState state) {
                      return  DirectionController();
                    },
                  ),
                ],
              ),
              GoRoute(
                path: '/addScreens/employee',
                name: 'AddEmployee',
                builder: (BuildContext context, GoRouterState state) {
                  return AddEmployeeController();
                },
              ),
              GoRoute(
                path: '/addScreens/direction',
                name: 'AddDirection',
                builder: (BuildContext context, GoRouterState state) {
                  return AddDirectionController();
                },
              )
            ],
          ),
        );
      },
    );
  }
}

/*final _router = GoRouter(
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
          path: '/addScreenemployees',
          builder: (BuildContext context, GoRouterState state) {
            return const EmployeesScreen();
          },
        ),
      ],
    ),
  ],
);*/
