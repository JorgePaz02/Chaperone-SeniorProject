import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

final db = FirebaseFirestore.instance;

Future<void> userSetup(String displayName) async {
  CollectionReference group = FirebaseFirestore.instance.collection('Users');

  final user = db.collection("Users");
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  final data = <String, dynamic>{
    'displayName': displayName,
    'group leader': false,
    'group': "N/A",
    'position-longitude': position.longitude,
    'position-latitute': position.latitude,
  };

  user.doc(displayName).set(data);
}
