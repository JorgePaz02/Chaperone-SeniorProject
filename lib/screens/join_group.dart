// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../UserInfo/joiningGroupmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JoinGroupScreen extends StatelessWidget {
  JoinGroupScreen({Key? key}) : super(key: key);
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    //Checks if user is in group already.
    final passcode = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 60), // Spacer
              Text(
                'Enter your group code:',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),

                SizedBox(height: 20.0), // Spacer
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: TextField(
                    controller: passcode,
                    decoration: InputDecoration(
                      labelText: "Group Code",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(height: 20.0), // Spacer
                ElevatedButton(
                  onPressed: () {
                    // Add your join group functionality here
                    FirebaseFirestore.instance
                        .collection('Groups')
                        .doc(passcode.text)
                        .get()
                        .then((DocumentSnapshot documentSnapshot) {
                      if (documentSnapshot.exists) {
                        if (documentSnapshot.get("number of members") ==
                            documentSnapshot.get("members").length) {
                          return Text("Group is already Full");
                        } else {
                          joininggroup(
                              passcode.text, auth.currentUser!.displayName);
                          Navigator.pushNamed(context, '/groupScreen');
                        }
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 16),
                    textStyle: const TextStyle(fontSize: 20),
                ),
                child: const Text('Join Group'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
