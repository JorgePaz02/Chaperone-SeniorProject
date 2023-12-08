import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class CreateItinerary extends StatefulWidget {
  const CreateItinerary({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CreateItineraryform();
  }
}

class CreateItineraryform extends State<CreateItinerary> {
  final event = TextEditingController();
  var datetime = DateTime.now();

  @override
  Widget build(BuildContext context) {
       void constantRefresh() {
      setState(() {});
    }

    Timer.periodic(const Duration(seconds: 5), (Timer t) => constantRefresh());   
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
              CupertinoButton(
                    onPressed: () => _showDialog(
                      CupertinoDatePicker(
                        initialDateTime: datetime,
                        use24hFormat: false,
                        onDateTimeChanged: (DateTime newTime) {
                          setState(() => datetime = newTime);
                        },
                      ),
                    ),
                    child: Text(
                      DateFormat('dd/MM/yyyy - hh:mm a').format(datetime),
                      style: const TextStyle(
                        fontSize: 22.0,
                      ),
                    ),
                  ),
              TextField(
                controller: event,
                keyboardType: TextInputType.multiline,
                maxLines: 1,
              ),
              TextButton(
                onPressed: () {
                  addItinerary({'date_time': Timestamp.fromDate(datetime),'event': event.text});
                },
                child: const Text("Add Event")
              )
            ]
          )
        )
      );
  }
}
