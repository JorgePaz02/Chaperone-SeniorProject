import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

Future<dynamic> listMessages() async {
  final FirebaseAuth auth = FirebaseAuth.instance;
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
      return value2.get('messages');
    });
  });
}

class _MessageScreenState extends State<MessageScreen> {
  final List<String> messages = [];
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void constantRefresh() {
      setState(() {});
    }

    Timer.periodic(const Duration(seconds: 5), (Timer t) => constantRefresh());

    void _submitMessage() {
      final message = messageController.text;
      if (message.isNotEmpty) {
        setState(() {
          messages.add(message);
          messageController.clear();
        });
      }
    }

    Future<void> sendMessage(String text) async {
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
          "messages":
              FieldValue.arrayUnion(["${auth.currentUser!.displayName}:$text"]),
        });
      });

      messageController.clear();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'lib/assets/Messages.png', // Update the path to your image
            fit: BoxFit.cover,
          ),
          Column(
            children: <Widget>[
              Expanded(
                child: FutureBuilder<dynamic>(
                    future: listMessages(),
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
                                title: Text(" ${snapshot.data[index]}"),
                              );
                            },
                          );
                        }
                      }
                      return const Text('');
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        decoration: const InputDecoration(
                          hintText: "Type your message...",
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        sendMessage(messageController.text);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
