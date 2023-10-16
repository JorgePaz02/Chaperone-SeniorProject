import 'package:cloud_firestore/cloud_firestore.dart';

final db = FirebaseFirestore.instance;

Future<void> groupSetup(String groupname, int num, String passcode) async {
  CollectionReference group = FirebaseFirestore.instance.collection('Groups');



final data = <String, dynamic>{
  "groupname": groupname,
  "number of members": num,
  "passcode": passcode,
  "members": []
};


  group.doc(passcode).set(data);
}
