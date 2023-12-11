import 'package:app/UserInfo/groupmodel.dart';
import 'package:app/UserInfo/joiningGroupasLeader.dart';
import 'package:app/screens/radius_update_screen.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:app/screens/create_group_screen.dart';
import '../UserInfo/joiningGroupmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../UserInfo/getUserLocation.dart';

String generateRandomCode({int length = 6}) {
  final random = Random();
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  return String.fromCharCodes(Iterable.generate(
    length,
    (_) => chars.codeUnitAt(random.nextInt(chars.length)),
  ));
}

class groupcreated extends StatefulWidget {
  groupcreated({required this.name, required this.passcode});
  final String name;
  final int passcode;

  @override
  State<StatefulWidget> createState() {
    return GroupCreatedScreen();
  }
}

class GroupCreatedScreen extends State<groupcreated> {
  final String randomCode = generateRandomCode();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent back navigation
        return false;
      },
      child: Scaffold(
        appBar: null, // Set the AppBar to null
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/assets/GroupMade.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 50.0),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "",
                    style: TextStyle(
                      fontSize: 48.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 240.0),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  child: Column(
                    children: <Widget>[
                      const Text(
                        "Your Group Code Is:",
                        style: TextStyle(
                          fontSize: 36.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 40.0),
                      Text(
                        randomCode,
                        style: const TextStyle(
                          fontSize: 72.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {
                        int radius = 0;
                        groupSetup(
                          widget.name,
                          widget.passcode,
                          randomCode,
                          auth.currentUser!.displayName,
                          radius,
                        );

                        joininggroupAsLeader(
                          randomCode,
                          auth.currentUser!.displayName,
                        );

                        Navigator.pushNamed(
                          context,
                          '/groupScreen',
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40.0,
                          vertical: 16.0,
                        ),
                      ),
                      child: const Text(
                        "Continue",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
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