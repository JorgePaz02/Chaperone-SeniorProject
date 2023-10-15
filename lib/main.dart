import 'package:app/announce_screen.dart';
import 'package:app/group_screen.dart';
import 'package:app/login_screen.dart';
import 'package:app/message_screen.dart';
import 'package:app/register_user.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'group_created_screen.dart';
import 'home_screen.dart';
import 'join_group.dart';
import 'main_screen.dart';
import 'create_group_screen.dart';

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
        '/welcome': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(), // Add a route for HomeScreen
        '/createGroup': (context) =>
            CreateGroupScreen(), // Add Create Group screen route
          //'/groupCreated': (context) => GroupCreatedScreen(), 
          '/Registration': (context) => const Registration(),
          '/joinGroup':(context) => JoinGroupScreen(), 
          '/groupScreen': (context) => const GroupScreen(), 
          '/announceScreen': (context) => const AnnouncementScreen(),
          "/messageScreen": (context) => const MessageScreen(),      },
    );
  }
}
