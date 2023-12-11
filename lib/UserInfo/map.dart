import 'dart:async';

import 'package:app/screens/message_screen.dart';
import 'package:app/screens/radius_update_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'getUserLocation.dart'; // Assuming this file contains your getUserLocation function


 Future<bool> isLeader() async {
      return await FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser!.displayName)
        .get()
        .then(
          (value) async {
            return value.get("group leader");
          }
        );
    }
    
Future<String> getGroupPasscode() async {
  try {
    final FirebaseAuth auth = FirebaseAuth.instance;
    String currentUserDisplayName = auth.currentUser!.displayName!;

    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('Users').doc(currentUserDisplayName).get();

    if (userSnapshot.exists) {
      String groupPasscode = userSnapshot.get('group');
      return groupPasscode;
    } else {
      throw ('User data not found');
    }
  } catch (e) {
    print('Error fetching group passcode: $e');
    return ''; // Return an empty string or handle the error accordingly
  }
}

Future<int> getRadius() async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  return await FirebaseFirestore.instance
      .collection('Users')
      .doc(auth.currentUser!.displayName)
      .get()
      .then((value) async {
    return await FirebaseFirestore.instance
        .collection('Groups')
        .doc(value.get('group'))
        .get()
        .then((value2) {
      return value2.get('radius');
    });
  });
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = Set<Marker>();
  Set<Circle> _circles = Set<Circle>();
  late double _circleRadius = 0.0; // Initialize _circleRadius with a default value
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    if (this.mounted) {
    getUserLocations();

    // Fetch circle radius and set it in the state initially

      getRadius().then((value) {
        if (this.mounted) {
          setState(() {
            _circleRadius = value.toDouble(); // Convert int to double
          });
        }
      });
    }

    _startPeriodicUpdates();

    _setInitialCameraPosition();
  }

 void _startPeriodicUpdates() {
  const updateInterval = Duration(seconds: 30);

  void updateUserLocations() async {
    if (this.mounted) {
      try {
        await getUserLocations();

        // Other update code...
        await getRadius().then((value) {
          if (this.mounted) {
            setState(() {
              _circleRadius = value.toDouble();
              // Other state updates if needed
            });
          }
        });
      } catch (e) {
        print('Error updating user locations: $e');
        // Handle the error accordingly
      }
    } else {
      _timer.cancel(); // Cancel the timer if the widget is disposed
    }
  }

  _timer = Timer.periodic(updateInterval, (timer) {
    updateUserLocations();
  });
}


  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _setInitialCameraPosition() {
    // Set a default initial camera position (e.g., center of the map)
    // This will be overridden once the leader's location is available
    _mapController?.moveCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(0, 0), // Center of the map
        12.0, // Initial zoom level
      ),
    );
  }

  Future<void> getUserLocations() async {
    // Retrieve user locations
    String passcode = await getGroupPasscode();
    // Assuming getGroupMembersWithLocations is defined somewhere to get user locations
    List<MemberLocation> userLocations = await getGroupMembersWithLocations(passcode);

    // Clear existing markers and circles
    _markers.clear();
    _circles.clear();

    // Modify the constant marker offset value as needed for better visual representation
    const double markerOffset = 0;

    // Assuming the leader's location is at the first index
    if (userLocations.isNotEmpty) {
      MemberLocation leaderLocation = userLocations[0];
      _circles.add(
        Circle(
          circleId: const CircleId('leader_circle'),
          center: LatLng(
            leaderLocation.location.latitude,
            leaderLocation.location.longitude,
          ),
          radius: _circleRadius,
          strokeWidth: 1,
          strokeColor: Colors.blue,
          fillColor: Colors.blue.withOpacity(0.2),
        ),
      );

      // Update the map and center it around the leader's location
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(
              leaderLocation.location.latitude,
              leaderLocation.location.longitude,
            ),
            12.0,
          ),
        );
      }

      // Add user locations as markers on the map with offset
      for (var i = 0; i < userLocations.length; i++) {
        var userLocation = userLocations[i];
        double lat = userLocation.location.latitude + (markerOffset * i);
        double lng = userLocation.location.longitude + (markerOffset * i);

        _markers.add(
          Marker(
            markerId: MarkerId(userLocation.memberName),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(
              title: userLocation.memberName,
              snippet: 'Location: $lat, $lng',
            ),
          ),
        );
      }

      if(this.mounted){setState(() {});}
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('User Locations Map'),
      actions: [
        FutureBuilder<bool>(
          future: isLeader(), // Check if the current user is a leader
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data == true) {
              // Show the radar icon only if the user is a leader
              return IconButton(
                icon: Icon(Icons.radar),
                onPressed: () {
                  RadiusUpdateDialog.show(context);
                },
              );
            } else {
              return SizedBox(); // Return an empty SizedBox if not a leader
            }
          },
        ),
      ],
    ),
    body: GoogleMap(
      onMapCreated: (controller) {
        if (this.mounted) {
          setState(() {
            _mapController = controller;
          });
        }
      },
      markers: _markers,
      circles: _circles,
      initialCameraPosition: CameraPosition(
        target: LatLng(0, 0),
        zoom: 12.0,
      ),
    ),
  );
}
}