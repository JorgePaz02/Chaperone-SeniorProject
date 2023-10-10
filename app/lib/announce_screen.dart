import 'package:flutter/material.dart';
class AnnouncementScreen extends StatelessWidget {
  const AnnouncementScreen({Key? key}) : super(key: key);
 @override
  Widget build(BuildContext context) {
    var data = 'Announcements';
    var borderRadius6 = const BorderRadius.only(
      bottomLeft: Radius.circular(12.0),
      bottomRight: Radius.circular(12.0),
    );
    var borderRadius5 = borderRadius6;
    var borderRadius4 = borderRadius5;
    var borderRadius3 = borderRadius4;
    var borderRadius2 = borderRadius3;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          data,
          style: const TextStyle(color: Colors.white), // White text color
        ),
        backgroundColor: Colors.black, // Black app bar color
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: double.infinity, // Full width
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[200], // Light gray background color
              borderRadius: borderRadius2,
            ),
            child: const Text(
              'You joined Group 100!',
              style: TextStyle(
                color: Colors.black, // Text color
                fontSize: 20.0, // Text font size
              ),
            ),
          ),
          // Add any additional content or widgets below the text box
        ],
      ),
    );
  }
}
