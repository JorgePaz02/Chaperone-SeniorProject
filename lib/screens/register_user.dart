import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app/UserInfo/usermodel.dart';
import 'package:app/screens/login_screen.dart';

class Registration extends StatelessWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    Future<void> registerUsingEmailPassword(
        {required String name,
        required String email,
        required String password}) async {
      try {
        UserCredential user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        User? updateUser = FirebaseAuth.instance.currentUser;
        updateUser!.updateDisplayName(name);
        userSetup(email);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e.toString());
      }
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'lib/assets/images/SignUpScreen.png',
            fit: BoxFit.cover,
          ),
          // Content
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).padding.top + kToolbarHeight,
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    // Other AppBar contents can be added here
                  ],
                ),
              ),
              // Rest of your content
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Set the text color to white
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: "Email",
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
                          await registerUsingEmailPassword(
                            name: emailController.text,
                            email: emailController.text,
                            password: passwordController.text,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 16),
                          textStyle: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        child: const Text("Sign Up"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
