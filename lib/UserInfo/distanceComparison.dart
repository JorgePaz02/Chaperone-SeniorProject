import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'getUserLocation.dart';
import 'dart:math';


void checkUserDistances(
    BuildContext context,
    List<MemberLocation> userLocations,
    int radius,
) {
  if (userLocations.isEmpty) {
    // You can show an empty list message or perform appropriate actions here.
    print('No user locations available.');
    return;
  }

  double leaderLatitude = userLocations[0].location.latitude;
  double leaderLongitude = userLocations[0].location.longitude;

  for (var userLocation in userLocations) {
    double latDifference = (leaderLatitude - userLocation.location.latitude).abs();
    double lonDifference = (leaderLongitude - userLocation.location.longitude).abs();

    if (latDifference > radius || lonDifference > radius) {
      // Alert the leader or perform necessary actions
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Alert'),
            content: Text(
              'User ${userLocation.memberName} is farther away than the specified radius.',
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
      // You can implement additional actions after showing the dialog if needed.
    }
  }
}
