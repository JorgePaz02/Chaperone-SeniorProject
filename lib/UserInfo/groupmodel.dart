import 'package:cloud_firestore/cloud_firestore.dart';

final db = FirebaseFirestore.instance;

Future<void> groupSetup(String groupname, int num, String passcode,displayName) async {
  CollectionReference group = FirebaseFirestore.instance.collection('Groups');
  var announcements = [];


final data = <String, dynamic>{
  "groupname": groupname,
  "number of members": num,
  "passcode": passcode,
  "members": [displayName],
  "announcements": announcements
};


  final docRef2 = db.collection("Users").doc(displayName);
  docRef2.update({
    "group leader":true, ///BUGGED
  });

  group.doc(passcode).set(data);
}
