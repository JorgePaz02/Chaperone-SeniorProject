import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'getUserLocation.dart';
import 'dart:math';

void checkUserDistances(
  BuildContext context,
  List<MemberLocation> userLocations,
  int radius,
) {
  if (userLocations.isEmpty) {
    print('No user locations available.');
    return;
  }

  double leaderLatitude = userLocations[0].location.latitude;
  double leaderLongitude = userLocations[0].location.longitude;

  List<MemberLocation> offendingUsers = [];

  for (var userLocation in userLocations) {
    double latDifference = (leaderLatitude - userLocation.location.latitude).abs();
    double lonDifference = (leaderLongitude - userLocation.location.longitude).abs();

    if (latDifference > radius || lonDifference > radius) {
      offendingUsers.add(userLocation);
    }
  }

  if (offendingUsers.isNotEmpty) {
    showOffendingUsersDialog(context, offendingUsers);
  }
}

Future<void> checkUserAndShowAlert(
  BuildContext context,
  List<MemberLocation> userLocations,
  int radius,
) async {
  // Check if the current user is the leader
  bool isUserLeader = await isLeader();

  // If the user is the leader, proceed with checking distances and showing alert
  if (isUserLeader) {
    checkUserDistances(context, userLocations, radius);
  } else {
    print('Current user is not the leader.');
  }
}

Future<bool> isLeader() async {
      final FirebaseAuth auth = FirebaseAuth.instance;
  // Your existing implementation to determine if the current user is the leader
  return await FirebaseFirestore.instance
      .collection('Users')
      .doc(auth.currentUser!.displayName)
      .get()
      .then((value) {
    if (value.get("group leader") == true) {
      return true;
    } else {
      return false;
    }
  });
}


void showOffendingUsersDialog(BuildContext context, List<MemberLocation> offendingUsers) {
  List<String> offendingUserNames = offendingUsers.map((user) => user.memberName).toList();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Alert'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Users farther away than the specified radius:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            for (var userName in offendingUserNames)
              Text('- $userName'),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}
