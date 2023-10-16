import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> joininggroup(passcode, displayName) async {
  final db = FirebaseFirestore.instance;

  final docRef = db.collection("Groups").doc(passcode);
  docRef.update({
    "members": FieldValue.arrayUnion([displayName]),
  });
  final docRef2 = db.collection("Users").doc(displayName);
  docRef2.update({
    "group": passcode,

  });
}
