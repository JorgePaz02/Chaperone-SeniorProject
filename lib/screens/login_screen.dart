import 'package:app/NotificationServices/notifi_service.dart';
import 'package:app/UserInfo/geolocator.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'group_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Import the file containing the startLocationUpdates function

String errorMessage = "";

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<bool> inGroup() async {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final db = FirebaseFirestore.instance;
      return await db
        .collection('Users')
        .doc(auth.currentUser!.displayName)
        .get()
        .then((value) async {
          return value.get("group") != "";
        }
      );
    }

  Future<void> _login(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: nameController.text,
        password: passwordController.text,
      );

      // Call the startLocationUpdates function when the user logs in
      startLocationUpdates(nameController.text);
      await inGroup().then((value) async {
        if(value) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => GroupScreen()));
        }
        else {
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
        }
      });
    } on FirebaseAuthException catch (e) {
      print(e.code);
      switch (e.code) {
        case 'invalid-credential':
          setState(() {
            nameError = 'The email address provided is invalid.';
            passwordError = 'The password provided is invalid.';
          });
          break;
        case 'channel-error':
          setState(() {
            nameError = nameController.text.isEmpty ? 'The email address provided is empty.' : '';
            passwordError = passwordController.text.isEmpty ? 'The password provided is empty.' : '';
          });
          break;     
      }
    } catch (e) {
      setState(() {
        passwordError = 'There has been an error. Please try again.';
        nameError = 'There has been an error. Please try again.';
      });
    }
  }

  String nameError = "";
  String passwordError = "";

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Welcome Back!",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30.0),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Username",
                  border: const OutlineInputBorder(),
                  errorText: nameError.isEmpty ? null : nameError,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: const OutlineInputBorder(),
                  errorText: passwordError.isEmpty ? null : passwordError,
                ),
                obscureText: true,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await _login(context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black, // Text color
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                textStyle: const TextStyle(
                  fontSize: 18,
                ),
              ),
              child: const Text("Log In"),
            ),
          ],
        ),
      ),
    );
  }
}
