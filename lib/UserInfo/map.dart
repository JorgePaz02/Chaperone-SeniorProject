import 'package:app/screens/radius_update_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'getUserLocation.dart'; // Assuming this file contains your getUserLocation function

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
  late double _circleRadius;

  @override
  void initState() {
    super.initState();
    // Call the function to retrieve user locations and display them on the map
    getUserLocations();
    // Fetch circle radius and set it in the state
    getRadius().then((value) {
      setState(() {
        _circleRadius = value.toDouble(); // Convert int to double
      });
    });

    // Set the initial camera position to the default location (0,0) before the leader's location is obtained
    _setInitialCameraPosition();
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
    const double markerOffset = 0.00001;

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
          strokeWidth: 2,
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
          IconButton(
            icon: Icon(Icons.radar),
            onPressed: () {
              // Display the radius update dialog when radar button is pressed
              RadiusUpdateDialog.show(context);
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