

import 'package:flutter/material.dart';
import 'dart:math';

String generateRandomCode({int length = 6}) {
  final random = Random();
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  return String.fromCharCodes(Iterable.generate(
    length,
    (_) => chars.codeUnitAt(random.nextInt(chars.length)),
  ));
}

// ignore: use_key_in_widget_constructors
class GroupCreatedScreen extends StatelessWidget {
  final String randomCode = generateRandomCode();

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
              padding: const EdgeInsets.all(16.0), // Add padding to create the text box
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black), // Border color
                borderRadius: BorderRadius.circular(0.0), // Rounded corners
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
                alignment: Alignment.center, // Align the button to the bottom center
                child: ElevatedButton(
                  onPressed: () {
                   Navigator.pushNamed(context, '/groupScreen');

                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black, // Set the button background color to black
                    padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 16.0), // Adjust padding as needed
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