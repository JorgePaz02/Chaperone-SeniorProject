import 'package:flutter/material.dart';
import 'create_group_screen.dart';
import 'main_screen.dart';
import 'welcome_screen.dart';
import 'home_screen.dart'; // Import the new screen

void main() {
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
