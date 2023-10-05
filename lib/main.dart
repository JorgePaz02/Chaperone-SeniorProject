import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const MainScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/home': (context) => const HomeScreen(), // Add a route for HomeScreen
        '/createGroup': (context) => CreateGroupScreen(), // Add Create Group screen route

      },
    );
  }
}
