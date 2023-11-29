import 'package:app/screens/create_itinerary.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItineraryScreen extends StatelessWidget {
  const ItineraryScreen({Key? key}) : super(key: key);

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
            ),
            child: FutureBuilder<dynamic>(
                future: listItinerary(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasData) {
                    if(snapshot.data.length != 0) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        prototypeItem: ListTile(
                          title: Text(snapshot.data.first['date_time'].toString() + ' - ' + snapshot.data.first['event'])
                        ),
                        itemBuilder: (context, index) {
                          DateTime timestamp = snapshot.data[index]['date_time'].toDate();
                          String datetime = DateFormat('dd/MM/yyyy - hh:mm a').format(timestamp);
                          return ListTile(
                            title: RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(text: datetime, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  TextSpan(text: ': ' + snapshot.data[index]['event']),
                                ],
                              ),
                            ),
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
                              return const Text('Nothing here yet. Make a new event!');
                            }
                            else {
                              return const Text('Nothing here yet. Check back soon for upcoming events!');
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
                            Navigator.push(context,
                              MaterialPageRoute(
                                builder: (context) => const CreateItinerary()
                              )
                            );
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
