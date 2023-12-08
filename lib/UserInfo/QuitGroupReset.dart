//ENTER CODE FOR WHEN GROUPLEADER LEAVES, GROUP DISBANDS

import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> userReset(String groupCode) async {
  final db = FirebaseFirestore.instance;
  db.collection("Groups").doc(groupCode).get().then((value) async {
    List members = value.get("members");
    for (var i in members) {
      final docRef = db.collection("Users").doc(i['name']);
      docRef.update({
        "group": "",
        "group leader": false,
      });
    }
    db.collection("Groups").doc(groupCode).delete();
  });
}
