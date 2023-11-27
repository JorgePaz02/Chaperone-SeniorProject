import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> joininggroupAsLeader(passcode, displayName) async {
  final db = FirebaseFirestore.instance;

  final docRef = db.collection("Groups").doc(passcode);
  docRef.update({
    "members": FieldValue.arrayUnion([displayName]),
  });
  final docRef2 = db.collection("Users").doc(displayName);
  docRef2.update({
    "group": passcode,

  });

    final docRef3 = db.collection("Users").doc(displayName);
  docRef3.update({
    "group leader":true, 
  });


}

  Future <void> updateRadius(passcode, radius) async{
    final db = FirebaseFirestore.instance;

  final docRef = db.collection("Groups").doc(passcode);
  docRef.update({
      "radius": radius,
    });
  }
