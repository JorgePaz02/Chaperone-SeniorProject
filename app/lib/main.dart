import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'announce_screen.dart'; // Import your announcement screen
import 'security_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Group 100',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Group 100'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _incrementCounter() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Colors.black, // Set the app bar background color to black
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white, // White text color
          ),
        ),
      ),
      body: const TwoColumnLayout(),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TwoColumnLayout extends StatelessWidget {
  const TwoColumnLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment
          .spaceEvenly, // Added to evenly space out the columns
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment
                .spaceEvenly, // Added to evenly space out the circles vertically
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AnnouncementScreen(),
                    ),
                  );
                },
                child: const CircleAnnouncement('Announcement'),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SecurityScreen(),
                    ),
                  );
                },
                child: const CircleAnnouncement('Security'),
              ),
              InkWell(
                onTap: () {
                  // Handle member list tap
                },
                child: const CircleAnnouncement('Member List'),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment
                .spaceEvenly, // Added to evenly space out the circles vertically
            children: <Widget>[
              InkWell(
                onTap: () {
                  // Handle messages tap
                },
                child: const CircleAnnouncement('Messages'),
              ),
              InkWell(
                onTap: () {
                  // Handle invitations tap
                },
                child: const CircleAnnouncement('Invitations'),
              ),
              InkWell(
                onTap: () {
                  // Handle options tap
                },
                child: const CircleAnnouncement('Options'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CircleAnnouncement extends StatelessWidget {
  final String text;

  // ignore: use_key_in_widget_constructors
  const CircleAnnouncement(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(
          color: Colors.black,
          width: 2.0,
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
