import 'package:app/screens/announce_screen.dart';
import 'package:app/screens/group_screen.dart';
import 'package:app/screens/login_screen.dart';
import 'package:app/screens/message_screen.dart';
import 'package:app/screens/radius_update_screen.dart';
import 'package:app/screens/register_user.dart';
import 'package:app/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart';
import 'screens/join_group.dart';
import 'screens/main_screen.dart';
import 'screens/create_group_screen.dart';

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
        '/': (context) => SplashScreen(),
        '/mainscreen':(context) => const MainScreen(),
        '/welcome': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(), // Add a route for HomeScreen
        '/createGroup': (context) => CreateGroupScreen(), // Add Create Group screen route
          //'/groupCreated': (context) => GroupCreatedScreen(), 
          '/Registration': (context) => const Registration(),
          '/joinGroup':(context) => JoinGroupScreen(), 
          '/groupScreen': (context) =>  GroupScreen(), 
          '/announceScreen': (context) => const AnnouncementScreen(),
          "/messageScreen": (context) => const MessageScreen(),             
          '/radius_update': (context) => RadiusUpdateScreen(), // Add a route for RadiusUpdateScreen
 },
          
    );
  }
}
