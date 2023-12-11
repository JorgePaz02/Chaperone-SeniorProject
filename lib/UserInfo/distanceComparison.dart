import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'getUserLocation.dart';
import 'dart:math';

const double earthRadius = 6371000; // Earth's radius in meters

double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  double dLat = (lat2 - lat1) * (pi / 180);
  double dLon = (lon2 - lon1) * (pi / 180);
  double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(lat1 * (pi / 180)) * cos(lat2 * (pi / 180)) *
      sin(dLon / 2) * sin(dLon / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  double distance = earthRadius * c;
  return distance.roundToDouble(); // Round the distance to the nearest whole number
}

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
    double distance = calculateDistance(
      leaderLatitude,
      leaderLongitude,
      userLocation.location.latitude,
      userLocation.location.longitude,
    );

    print('Leader Latitude: $leaderLatitude');
    print('Leader Longitude: $leaderLongitude');
    print('User Latitude: ${userLocation.location.latitude}');
    print('User Longitude: ${userLocation.location.longitude}');
    print('Distance: $distance meters'); // Print the calculated distance

    if (distance > radius) {
      offendingUsers.add(userLocation);
    }
  }

  if (offendingUsers.isNotEmpty) {
    showOffendingUsersDialog(context, offendingUsers);
  }
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
