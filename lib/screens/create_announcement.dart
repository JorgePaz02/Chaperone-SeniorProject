import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateAnnouncement extends StatefulWidget {
  const CreateAnnouncement({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CreateAnnouncementform();
  }
}

class CreateAnnouncementform extends State<CreateAnnouncement> {
  final announcement = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Future<void> addAnnouncement(String X) async {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final db = FirebaseFirestore.instance;
          db
          .collection("Users")
          .doc(auth.currentUser!.displayName)
          .get()
          .then((value) async {
        String passcode = value.get("group");
        final docRef = db.collection("Groups").doc(passcode);
       docRef.update({
    "announcements": FieldValue.arrayUnion([X]),
      });


  });

    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
              TextField(
                controller: announcement,
                keyboardType: TextInputType.multiline,
                maxLines: 10,
              ),
              TextButton(
                  onPressed: () {
                    addAnnouncement(announcement.text);
                    Navigator.pushNamed(context, '/announceScreen');
                  },
                  child: const Text("Add Announcement"))
            ])));
  }
}
