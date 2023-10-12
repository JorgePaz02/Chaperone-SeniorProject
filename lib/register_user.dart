import 'package:app/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app/UserInfo/usermodel.dart';

class Registration extends StatelessWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
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
              "Please Sign Up",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
             const SizedBox(height: 30.0),
             Padding(
              // ignore: prefer_const_constructors
              padding: EdgeInsets.all(16.0),
              child: TextField(
                 controller: emailController,
                 // ignore: prefer_const_constructors
                decoration: InputDecoration(
                  labelText: "Email",
                  // ignore: prefer_const_constructors
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              // ignore: prefer_const_constructors
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: passwordController,
                // ignore: prefer_const_constructors
                decoration: InputDecoration(
                  labelText: "Password",
                  // ignore: prefer_const_constructors
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
               // registerUsingEmailPassword(name: emailController.text, email: emailController.text, password:passwordController.text);
                  try {
            UserCredential user =
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text,
            );
            User? updateUser = FirebaseAuth.instance.currentUser;
            updateUser!.updateDisplayName(emailController.text);
            userSetup(emailController.text);
          } on FirebaseAuthException catch (e) {
            if (e.code == 'weak-password') {
              print('The password provided is too weak.');
            } else if (e.code == 'email-already-in-use') {
              print('The account already exists for that email.');
            }
          } catch (e) {
            print(e.toString());
          }
        
                // Add your Sign up button functionality here
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.black, // Text color
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                textStyle: const TextStyle(
                  fontSize: 18,
                ),
              ),
              child: const Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}



Future<User?> registerUsingEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = userCredential.user;
      await user!.updateDisplayName(name);
      await user.reload();
      user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }

    return user;
  }