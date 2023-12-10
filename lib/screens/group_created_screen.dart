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


class groupcreated extends StatefulWidget{
 groupcreated({required this.name, required this.passcode});
  final String name;
  final int passcode;
 
  // etc
  @override
  State<StatefulWidget> createState() { return GroupCreatedScreen();}
}

// ignore: use_key_in_widget_constructors
class GroupCreatedScreen extends State<groupcreated> {



  final groupnames = CreateGroupScreen().groupname;
  final numbers = CreateGroupScreen().number;
  final String randomCode = generateRandomCode();
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 50.0),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Your group has been made!",
                style: TextStyle(
                  fontSize: 48.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 120.0), // Add spacing between text and code
            Container(
              padding: const EdgeInsets.all(
                  16.0), // Add padding to create the text box
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black), // Border color
                borderRadius: BorderRadius.circular(0.0), // Rounded corners
              ),
              child: Column(
                children: <Widget>[
                  const Text(
                    "Your Group Code is:",
                    style: TextStyle(
                      fontSize: 36.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40.0), // Add spacing
                  Text(
                    randomCode, // Display the generated random code
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
                alignment:
                    Alignment.center, // Align the button to the bottom center
                child: ElevatedButton(
                 onPressed: () {
  int radius = 0; // Replace this with your actual radius value
  groupSetup(
    widget.name,
    widget.passcode,
    randomCode,
    auth.currentUser!.displayName,
    radius,
  );

  joininggroupAsLeader(randomCode, auth.currentUser!.displayName);

  
  // Navigate to the '/groupScreen' route and pass 'randomCode' as a parameter
  Navigator.pushNamed(
    context,
    '/groupScreen' // Pass 'randomCode' as an argument
  );
},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors
                        .black, // Set the button background color to black
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40.0,
                        vertical: 16.0), // Adjust padding as needed
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 18.0, // Set the font size for the button text
                      color: Colors.white, // Set the text color to white
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
