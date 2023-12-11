import 'package:app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app/UserInfo/usermodel.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {

  String emailError = "";
  String passwordError = "";

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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Sign Up",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
             const SizedBox(
              height: 30.0
            ),
             Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: const OutlineInputBorder(),
                  errorText: emailError.isEmpty ? null : emailError,
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
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );
    User? updateUser = FirebaseAuth.instance.currentUser;
    updateUser!.updateDisplayName(emailController.text);
    userSetup(emailController.text);
    // Send email verification
    await updateUser.sendEmailVerification();
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  } on FirebaseAuthException catch (e) {
    if (this.mounted) {
      switch (e.code) {
        case 'email-already-in-use':
          setState(() {
            emailError = 'The email address provided is already in use for an account.';
            passwordError = '';
          });
          break;
        case 'invalid-email':
          setState(() {
            emailError = 'The email address provided is invalid.';
            passwordError = '';
          });
          break;
        case 'weak-password':
          setState(() {
            passwordError = 'The password provided is not strong enough for use.';
            emailError = '';
          });
          break;
        case 'channel-error':
          setState(() {
            emailError = emailController.text.isEmpty ? 'The email address provided is empty.' : '';
            passwordError = passwordController.text.isEmpty ? 'The password provided is empty.' : '';
          });
          break;     
      }
    }
  } catch (e) {
    if (this.mounted) {
      setState(() {
        passwordError = 'There has been an error. Please try again.';
        emailError = 'There has been an error. Please try again.';
      });
    }
  }
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