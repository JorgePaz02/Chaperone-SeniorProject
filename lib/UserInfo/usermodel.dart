import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

final db = FirebaseFirestore.instance;

Future<void> userSetup(String displayName) async {


  final user = db.collection("Users");


  final data = <String, dynamic>{
    'displayName': displayName,
    'group leader': false,
    'group': "",
  };

  user.doc(displayName).set(data);
}
