import 'package:app/screens/create_announcement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _AnnouncementScreen();}
}
class _AnnouncementScreen extends State<AnnouncementScreen> {
  @override
  Widget build(BuildContext context) {
       void constantRefresh() {
      setState(() {});
    }

    Timer.periodic(const Duration(seconds: 5), (Timer t) => constantRefresh());   
    final FirebaseAuth auth = FirebaseAuth.instance;
    Future<bool> isLeader() async {
      return await FirebaseFirestore.instance
          .collection('Users')
          .doc(auth.currentUser!.displayName)
          .get()
          .then((value) async {
        if (value.get("group leader") == true) {
          return true;
        } else {
          return false;
        }
      });
    }

    Future<dynamic> listAnnouncements() async {
      return await FirebaseFirestore.instance
          .collection('Users')
          .doc(auth.currentUser!.displayName)
          .get()
          .then((value) async {
        return await FirebaseFirestore.instance
            .collection('Groups')
            .doc(value.get('group'))
            .get()
            .then((value2) {
          return value2.get('announcements');
        });
      });
    }

    var data = 'Announcements';
    var borderRadius6 = const BorderRadius.only(
      bottomLeft: Radius.circular(12.0),
      bottomRight: Radius.circular(12.0),
    );
    var borderRadius5 = borderRadius6;
    var borderRadius4 = borderRadius5;
    var borderRadius3 = borderRadius4;
    var borderRadius2 = borderRadius3;
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: double.infinity, // Full width
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[200], // Light gray background color
              borderRadius: borderRadius2,
            ),
            child: const Text(
              'You joined Group 100!',
              style: TextStyle(
                color: Colors.black, // Text color
                fontSize: 20.0, // Text font size
              ),
            ),
          ),
          // Add any additional content or widgets below the text box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[200], // Light gray background color
              borderRadius: borderRadius2,
            ),
            child: FutureBuilder<dynamic>(
                future: listAnnouncements(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.length != 0) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        prototypeItem: ListTile(
                          title: Text(snapshot.data.first),
                        ),
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(snapshot.data[index]),
                          );
                        },
                      );
                    } else {
                      return FutureBuilder<dynamic>(
                          future: isLeader(),
                          builder: (BuildContext context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data == true) {
                                return const Text(
                                    'Nothing here yet. Make a new annoucement!');
                              } else {
                                return const Text(
                                    'Nothing here yet. Check back soon for upcoming annoucements!');
                              }
                            }
                            return const Text('');
                          });
                    }
                  }
                  return const Text('');
                }),
          ),

          SizedBox(
              width: 30,
              child: FutureBuilder<dynamic>(
                  future: isLeader(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data == true) {
                        return FloatingActionButton(
                          child: const Icon(Icons.add),
                          backgroundColor: const Color(0xff03dac6),
                          foregroundColor: Colors.black,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    // ignore: unnecessary_new
                                    builder: (context) =>
                                        const CreateAnnouncement()));
                          },
                        );
                      }
                    }
                    return const Text('');
                  }))
        ],
      ),
    );
  }
}
