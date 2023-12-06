import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnnouncementScreen extends StatefulWidget {
  AnnouncementScreen({Key? key}) : super(key: key);

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  final TextEditingController announcementController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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

    Future<void> addAnnouncement(Map<String, Object> X) async {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final db = FirebaseFirestore.instance;
        db
        .collection("Users")
        .doc(auth.currentUser!.displayName)
        .get()
        .then((value) async {
          String passcode = value.get("group");
          final docRef = db.collection("Groups").doc(passcode);
          docRef.update(
          {
            "announcements": FieldValue.arrayUnion([X]),
          }            
          );
        }
      );
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
        title: const Row(
          children: [
            Icon(
              Icons.announcement,
              color: Colors.blue
            ),
            SizedBox(
              width: 10
            ),
            Text(
              'Announcements',
              style: TextStyle(
                color: Colors.black
              )
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Add any additional content or widgets below the text box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[200], // Light gray background color
              // borderRadius: borderRadius2,
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
                          title: Text(snapshot.data.first['announcement']),
                        ),
                        itemBuilder: (context, index) {
                          DateTime timestamp = snapshot.data[index]['date_time'].toDate();
                          String datetime = DateFormat('dd/MM/yyyy - hh:mm a').format(timestamp);
                          return ListTile(
                            title: Text(snapshot.data[index]['announcement']),
                            trailing: Text(datetime)
                          );
                        },
                      );
                    }
                    else {
                      return FutureBuilder<dynamic>(
                        future: isLeader(),
                        builder: (BuildContext context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data == true) {
                              return const Text('Nothing here yet. Make a new annoucement!');
                            }
                            else {
                              return const Text('Nothing here yet. Check back soon for upcoming annoucements!');
                            }
                          }
                          return const Text('');
                        }
                      );
                    }
                  }
                  return const Text('');
                }),
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
          ),
          SizedBox(
            child: FutureBuilder<dynamic>(
              future: isLeader(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == true) {
                    return ElevatedButton(
                      onPressed: () {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Make Annoucement'),
                            content: SizedBox(
                              width: double.maxFinite,
                              child: TextField(
                                controller: announcementController,
                                decoration: const InputDecoration(
                                  labelText: "Announcement",
                                  border: OutlineInputBorder(),
                                ),
                                maxLines: null,
                              ),
                            ),      
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  DateTime datetime = DateTime.now();
                                  addAnnouncement({'announcement': announcementController.text, 'date_time': Timestamp.fromDate(
                                    DateTime(
                                        datetime.year,
                                        datetime.month,
                                        datetime.day,
                                        datetime.hour,
                                        datetime.minute,
                                      )
                                    )});
                                  Navigator.pop(context);
                                  announcementController.text = '';
                                  setState(() {});
                                },
                                child: const Text('Submit'),
                              ),
                            ],
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black, // Text color
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 16
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      child: const Text("Create New Announcement"),
                    );
                  }
                }
                return const Text('');
              }
            )
          )
        ],
      ),
    );
  }
}