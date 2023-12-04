import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {

    void checkGroup() {
      FirebaseFirestore.instance
          .collection('Users')
          .doc(auth.currentUser!.displayName)
          .get()
          .then((value) {
          if (value.get('group') != "") {
            Navigator.pushNamed(context, '/groupScreen');
          }
          });
    }

    checkGroup();

    return Scaffold(
      appBar: null,
      body: Stack(
        children: <Widget>[
          const Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: Text(
                "Hello!",
                style: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: CircleAvatar(
                radius: 36.0,
                backgroundColor: Colors.grey, // Example background color
                // You can add the user's image here with Image.asset or Image.network
                // Example: backgroundImage: AssetImage('assets/user_avatar.png'),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "What do you want to do today?",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20.0), // Add spacing between text and buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/createGroup');
                          },
                          child: const CircleAvatar(
                            radius: 60.0,
                            backgroundColor: Colors.blue, // Background color of the circle button
                            child: Padding(
                              padding: EdgeInsets.all(8.0), // Add padding
                              child: Icon(Icons.person_add, size: 48.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0), // Add spacing between text and button
                        const Text(
                          "Create Group",
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 80.0), // Add spacing between buttons
                    Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/joinGroup');
                          },
                          child: const CircleAvatar(
                            radius: 60.0,
                            backgroundColor: Colors.green, // Background color of the circle button
                            child: Padding(
                              padding: EdgeInsets.all(8.0), // Add padding
                              child: Icon(Icons.group_add, size: 48.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0), // Add spacing between text and button
                        const Text(
                          "Join Group",
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}