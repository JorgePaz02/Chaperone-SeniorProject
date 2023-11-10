import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupScreen extends StatelessWidget {
  const GroupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    Future groupname() async {
     return await FirebaseFirestore.instance
          .collection('Users')
          .doc(auth.currentUser!.displayName)
          .get()
          .then((value) {
        if (value.get('group') != "") {
          print(value.get('group'));
          return value.get('group');
        }
      });
  
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("" + groupname().toString(),
            style: const TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: 2, // Two columns
          padding: const EdgeInsets.all(16.0),
          mainAxisSpacing: 16.0, // Spacing between rows
          crossAxisSpacing: 16.0, // Spacing between columns
          children: <Widget>[
            _buildCircularButton(
                Icons.announcement, "Announcements", Colors.blue, () {
              Navigator.pushNamed(context, '/announceScreen');

              print("Announcements button tapped");
            }),
            _buildCircularButton(Icons.message, "Messages", Colors.green, () {
              // Add functionality for Messages button here
              Navigator.pushNamed(context, "/messageScreen");
            }),
            _buildCircularButton(Icons.health_and_safety, "Safety", Colors.red,
                () {
              // Add functionality for Safety button here
              print("Safety button tapped");
            }),
            _buildCircularButton(Icons.mail, "Invitations", Colors.orange, () {
              // Add functionality for Invitations button here
              print("Invitations button tapped");
            }),
            _buildCircularButton(Icons.group, "Member List", Colors.purple, () {
              // Add functionality for Member List button here
              print("Member List button tapped");
            }),
            _buildCircularButton(Icons.settings, "Options", Colors.teal, () {
              // Add functionality for Options button here
              print("Options button tapped");
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularButton(
      IconData icon, String label, Color color, VoidCallback onPressed) {
    return InkWell(
      onTap:
          onPressed, // Use the provided onPressed callback for individual functionality
      child: Container(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 30.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 36.0,
                color: color,
              ),
              const SizedBox(height: 8.0),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
