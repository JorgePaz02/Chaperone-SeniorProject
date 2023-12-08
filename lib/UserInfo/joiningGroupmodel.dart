// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> joininggroup(passcode, displayName) async {
  final db = FirebaseFirestore.instance;

  final docRef = db.collection("Groups").doc(passcode);
  docRef.update({
    "members": FieldValue.arrayUnion([
      {
        'name': displayName,
      }
      ]
    ),
  });


  final docRef2 = db.collection("Users").doc(displayName);
  docRef2.update({
    "group": passcode,

  });

      final docRef3 = db.collection("Users").doc(displayName);
  docRef3.update({
    "group leader":false, 
  });
}



