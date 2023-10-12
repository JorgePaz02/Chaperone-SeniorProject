import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
final db = FirebaseFirestore.instance;


Future<void> userSetup(String displayName) async {
 CollectionReference group = FirebaseFirestore.instance.collection('Users');

  final user = db.collection("Users");

final data = <String, dynamic>{
  'displayName': displayName,
  'group leader': false,
  'group': "N/A"
};


  user.doc(displayName).set(data);
}



 