import 'package:app/screens/register_user.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null, // Set the AppBar to null to remove it
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Party Patrol",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30.0),
            ButtonBar(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/welcome');
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: Colors.white, // Text color
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16), // Button padding
                    textStyle: const TextStyle(
                      fontSize: 18, // Text size
                    ),
                    side: const BorderSide(color: Colors.black), // Button border color
                  ),
                  child: const Text("Log In"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Registration()),
                );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: Colors.white, // Text color
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16), // Button padding
                    textStyle: const TextStyle(
                      fontSize: 18, // Text size
                    ),
                    side: const BorderSide(color: Colors.black), // Button border color
                  ),
                  child: const Text("Sign Up"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
