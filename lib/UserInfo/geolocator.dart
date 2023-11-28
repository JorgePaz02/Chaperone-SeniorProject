import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;

void startLocationUpdates(String displayName) async {

  try {
    // Start listening for real-time location updates
      Geolocator.getPositionStream().listen((Position position) async {
    await db.collection('Users').doc(displayName).update({
      'position': GeoPoint(position.latitude, position.longitude),
    }).then((value) {
      print("Location updated successfully: ${position.latitude}, ${position.longitude}");
    }).catchError((error) {
      print("Failed to update location: $error");
    });
  });
  } catch (e) {
    print("Error: $e");
  }
}
