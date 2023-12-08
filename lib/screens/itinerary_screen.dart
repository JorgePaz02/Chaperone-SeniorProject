import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class ItineraryScreen extends StatefulWidget {
  const ItineraryScreen({Key? key}) : super(key: key);

  @override
  State<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> {
  final TextEditingController eventController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  var now = DateTime.now();

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

    Future<dynamic> listItinerary() async {
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
          return value2.get('itinerary');
        });
      });
    }

    Future<void> addItinerary(Map<String, Object> X) async {
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
    'itinerary': FieldValue.arrayUnion([X]),
      });
  });
    }

    Future<void> deleteItinerary(Map<String, Object> X) async {
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
            "itinerary": FieldValue.arrayRemove([X]),
          }            
          );
        }
      );
    }

    void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Row(
          children: [
            Icon(
              Icons.access_time,
              color: Colors.green
            ),
            SizedBox(
              width: 10
            ),
            Text(
              'Itinerary',
              style: TextStyle(
                color: Colors.black
              )
            ),
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
              future: listItinerary(),
              builder: (BuildContext context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const CircularProgressIndicator();
                  default:
                    if (snapshot.hasError) {
                      return Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle (
                          color: Colors.red,
                        ),
                      );
                    }
                    else {
                      if (snapshot.hasData) {
                        if (snapshot.data.length != 0) {
                            return Flexible (
                              child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              String event = snapshot.data[index]['event'];
                              String description = snapshot.data[index]['description'];
                              Timestamp date_time = snapshot.data[index]['date_time'];
                              DateTime timestamp = snapshot.data[index]['date_time'].toDate();
                              String datetime = DateFormat('dd/MM/yyyy - hh:mm a').format(timestamp);
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: const BorderSide(color: Colors.grey),
                                    bottom: BorderSide(color: index < snapshot.data.length - 1 ? Colors.transparent : Colors.grey),
                                  ),
                                ),
                                child: Row(
                                  children: <Widget> [
                                    Container (
                                      constraints: const BoxConstraints(
                                        maxWidth: 300,
                                      ),
                                      child: Column(
                                        children: <Widget> [
                                          TextButton(
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: RichText(
                                                text: TextSpan(
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: '$datetime: ',
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold
                                                      )
                                                    ),
                                                    TextSpan(
                                                      text: snapshot.data[index]['event']
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) => AlertDialog(
                                              title: Text("$datetime: ${snapshot.data[index]['event']}"),
                                              content: Text(snapshot.data[index]['description']),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            ),
                                            );
                                            },
                                          ),
                                        ]
                                      ),
                                      padding: const EdgeInsets.all(4.0),
                                    ),
                                    Expanded(
                                      child: Container(
                                      ),
                                    ),
                                    const Padding (
                                      padding: EdgeInsets.all(8.0),
                                    ),
                                    Container (
                                      child: FutureBuilder<dynamic>(
                                        future: isLeader(),
                                        builder: (BuildContext context, snapshot) {
                                          switch (snapshot.connectionState) {
                                            case ConnectionState.waiting:
                                              return const CircularProgressIndicator();
                                            default:
                                              if (snapshot.hasError) {
                                                return Text(
                                                  'Error: ${snapshot.error}',
                                                  style: const TextStyle (
                                                    color: Colors.red,
                                                  ),
                                                );
                                              }
                                              else {
                                                if (snapshot.hasData) {
                                                  if (snapshot.data) {
                                                    return IconButton(
                                                      icon: const Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                      ),
                                                      onPressed: () {
                                                        showDialog<String>(
                                                          context: context,
                                                          builder: (BuildContext context) => AlertDialog(
                                                            title: const Text('Delete this event?'),
                                                            content: const Text('If you delete this event, it will be gone permenantly!'),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                onPressed: () => Navigator.pop(context),
                                                                child: const Text('Cancel'),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  deleteItinerary({
                                                                    'date_time': date_time,
                                                                    'description': description,
                                                                    'event': event,
                                                                  });
                                                                  Navigator.pop(context);
                                                                  setState(() {});
                                                                },
                                                                child: const Text('OK'),
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
                                  ]
                                ),
                              );
                            }
                          )
                            );
                        }
                        else {
                          return Container (
                            child: const Text('No events available yet!'),
                            padding: const EdgeInsets.all(16.0),
                          );
                        }
                      }
                  }
                }
                return const SizedBox.shrink();
              }
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: FutureBuilder<dynamic>(
                future: isLeader(),
                builder: (BuildContext context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const CircularProgressIndicator();
                    default:
                      if (snapshot.hasError) {
                        return Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle (
                            color: Colors.red,
                          ),
                        );
                      }
                      else {
                        if (snapshot.hasData) {
                          if (snapshot.data) {
                            return ElevatedButton(
                              child: const Text('Add New Event'),
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
                              onPressed: () {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    title: const Text('Make an Event!'),
                                    content: Form(
                                      child: SingleChildScrollView(
                                        child: Column (
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget> [
                                            CupertinoButton(
                                              onPressed: () => _showDialog(
                                                CupertinoDatePicker(
                                                  initialDateTime: now,
                                                  use24hFormat: false,
                                                  onDateTimeChanged: (DateTime newTime) {
                                                    setState(() => now = newTime);
                                                  },
                                                ),
                                              ),
                                              child: Text(
                                                DateFormat('dd/MM/yyyy - hh:mm a').format(now),
                                                style: const TextStyle(
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                            ),
                                            TextFormField(
                                              controller: eventController,
                                              decoration: const InputDecoration(
                                                border: UnderlineInputBorder(),
                                                labelText: 'Event',
                                              ),
                                            ),
                                            TextFormField(
                                              controller: descriptionController,
                                              decoration: const InputDecoration(
                                                border: UnderlineInputBorder(),
                                                labelText: 'Description',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),      
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          addItinerary(
                                            {
                                              'date_time': Timestamp.fromDate(now),
                                              'description': descriptionController.text,
                                              'event': eventController.text,
                                            }
                                          );
                                          Navigator.pop(context);
                                          eventController.text = '';
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
              )
            )
          ],
        ),
      ),
    );
  }
}
