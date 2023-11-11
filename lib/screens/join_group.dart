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
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 120), // Spacer
              SizedBox(
                width: 300, // Adjust the width as needed
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Group Code',
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                  controller: passcode,
                ),
              ),
              SizedBox(height: 40), // Spacer
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Add your join group functionality here
            FirebaseFirestore.instance
                .collection('Groups')
                .doc(passcode.text)
                .get()
                .then((DocumentSnapshot documentSnapshot) {
              if (documentSnapshot.exists) {
                joininggroup(passcode.text, auth.currentUser!.displayName);
                Navigator.pushNamed(context, '/groupScreen');
              }
            });
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            textStyle: const TextStyle(fontSize: 20),
          ),
          child: const Text('Join'),
        ),
      ),
    );
  }
}
