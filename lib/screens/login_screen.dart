import 'package:app/NotificationServices/notifi_service.dart';
import 'package:app/UserInfo/geolocator.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'group_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Import the file containing the startLocationUpdates function

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
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
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Call the startLocationUpdates function when the user logs in
      startLocationUpdates(emailController.text);


      await inGroup().then((value) async {
        if(value) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => GroupScreen()));
        }
        else {
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
        }
      });


    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

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
      body: Center(
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
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
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
