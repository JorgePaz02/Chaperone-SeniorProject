import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({Key? key}) : super(key: key);

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  final TextEditingController announcementController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

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
        docRef.update({
          "announcements": FieldValue.arrayUnion([X]),
        });
      });
    }

    Future<void> deleteAnnouncement(Map<String, Object> X) async {
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
          "announcements": FieldValue.arrayRemove([X]),
        });
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Row(
          children: [
            Icon(Icons.announcement, color: Colors.blue),
            SizedBox(width: 10),
            Text('Announcements', style: TextStyle(color: Colors.black)),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FutureBuilder<dynamic>(
                future: listAnnouncements(),
                builder: (BuildContext context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      
                    default:
                      if (snapshot.hasError) {
                        return Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(
                            color: Colors.red,
                          ),
                        );
                      } else {
                        if (snapshot.hasData) {
                          if (snapshot.data.length != 0) {
                            return Flexible(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, index) {
                                      String announcement =
                                          snapshot.data[index]['announcement'];
                                      String description =
                                          snapshot.data[index]['description'];
                                      Timestamp date_time =
                                          snapshot.data[index]['date_time'];
                                      DateTime timestamp = snapshot.data[index]
                                              ['date_time']
                                          .toDate();
                                      String datetime =
                                          DateFormat('dd/MM/yyyy - hh:mm a')
                                              .format(timestamp);
                                      return Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            top: const BorderSide(
                                                color: Colors.grey),
                                            bottom: BorderSide(
                                                color: index <
                                                        snapshot.data.length - 1
                                                    ? Colors.transparent
                                                    : Colors.grey),
                                          ),
                                        ),
                                        child: Row(children: <Widget>[
                                          Container(
                                            constraints: const BoxConstraints(
                                                maxWidth: 150),
                                            child: Column(children: <Widget>[
                                              TextButton(
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                      snapshot.data[index]
                                                          ['announcement'],
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                onPressed: () {
                                                  showDialog<String>(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        AlertDialog(
                                                      title: Text(
                                                          snapshot.data[index]
                                                              ['announcement']),
                                                      content: Text(
                                                          snapshot.data[index]
                                                              ['description']),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child:
                                                              const Text('OK'),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ]),
                                            padding: const EdgeInsets.all(4.0),
                                          ),
                                          Expanded(
                                            child: Container(),
                                          ),
                                          Container(
                                            child: Column(
                                              children: <Widget>[
                                                Text(datetime,
                                                    style: const TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ))
                                              ],
                                            ),
                                            padding: const EdgeInsets.all(4.0),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                          ),
                                          Container(
                                            child: FutureBuilder<dynamic>(
                                              future: isLeader(),
                                              builder: (BuildContext context,
                                                  snapshot) {
                                                switch (
                                                    snapshot.connectionState) {
                                                  case ConnectionState.waiting:
                                                   
                                                  default:
                                                    if (snapshot.hasError) {
                                                      return Text(
                                                        'Error: ${snapshot.error}',
                                                        style: const TextStyle(
                                                          color: Colors.red,
                                                        ),
                                                      );
                                                    } else {
                                                      if (snapshot.hasData) {
                                                        if (snapshot.data) {
                                                          return IconButton(
                                                            icon: const Icon(
                                                              Icons.delete,
                                                              color: Colors.red,
                                                            ),
                                                            onPressed: () {
                                                              showDialog<
                                                                  String>(
                                                                context:
                                                                    context,
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    AlertDialog(
                                                                  title: const Text(
                                                                      'Delete this announcement?'),
                                                                  content:
                                                                      const Text(
                                                                          'If you delete this announcement, it will be gone permenantly!'),
                                                                  actions: <Widget>[
                                                                    TextButton(
                                                                      onPressed:
                                                                          () =>
                                                                              Navigator.pop(context),
                                                                      child: const Text(
                                                                          'Cancel'),
                                                                    ),
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        deleteAnnouncement({
                                                                          'announcement':
                                                                              announcement,
                                                                          'date_time':
                                                                              date_time,
                                                                          'description':
                                                                              description,
                                                                        });
                                                                        Navigator.pop(
                                                                            context);
                                                                        setState(
                                                                            () {});
                                                                      },
                                                                      child: const Text(
                                                                          'OK'),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        }
                                                      }
                                                    }
                                                }
                                                return const SizedBox.shrink();
                                              },
                                            ),
                                          ),
                                        ]),
                                      );
                                    }));
                          } else {
                            return Container(
                              child:
                                  const Text('No announcements available yet!'),
                              padding: const EdgeInsets.all(16.0),
                            );
                          }
                        }
                      }
                  }
                  return const SizedBox.shrink();
                }),
            Container(
                padding: const EdgeInsets.all(16.0),
                child: FutureBuilder<dynamic>(
                  future: isLeader(),
                  builder: (BuildContext context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                       
                      default:
                        if (snapshot.hasError) {
                          return Text(
                            'Error: ${snapshot.error}',
                            style: const TextStyle(
                              color: Colors.red,
                            ),
                          );
                        } else {
                          if (snapshot.hasData) {
                            if (snapshot.data) {
                              return ElevatedButton(
                                child: const Text('Add New Anouncement'),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.black, // Text color
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 16),
                                  textStyle: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                onPressed: () {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text('Make an Annoucement!'),
                                      content: Form(
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              TextFormField(
                                                controller:
                                                    announcementController,
                                                decoration:
                                                    const InputDecoration(
                                                  border:
                                                      UnderlineInputBorder(),
                                                  labelText: 'Announcement',
                                                ),
                                              ),
                                              TextFormField(
                                                controller:
                                                    descriptionController,
                                                decoration:
                                                    const InputDecoration(
                                                  border:
                                                      UnderlineInputBorder(),
                                                  labelText: 'Description',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            addAnnouncement({
                                              'announcement':
                                                  announcementController.text,
                                              'date_time': Timestamp.fromDate(
                                                  DateTime.now()),
                                              'description':
                                                  descriptionController.text,
                                            });
                                            Navigator.pop(context);
                                            announcementController.text = '';
                                            descriptionController.text = '';
                                            setState(() {});
                                          },
                                          child: const Text('Submit'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }
                          }
                        }
                    }
                    return const SizedBox.shrink();
                  },
                ))
          ],
        ),
      ),
    );
  }
}
