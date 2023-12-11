import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      if (this.mounted) {
        setState(() {});
      }
    }

    Timer.periodic(const Duration(seconds: 1), (Timer t) => constantRefresh());

    Future<void> sendMessage(String text) async {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final db = FirebaseFirestore.instance;
      final currentUser = auth.currentUser;

      if (text.isNotEmpty && currentUser != null) {
        // Check if the message is not empty
        final userDoc =
            await db.collection("Users").doc(currentUser.displayName).get();
        final passcode = userDoc.get("group");
        final docRef = db.collection("Groups").doc(passcode);
        final timestamp = DateTime.now();
        String datetime = DateFormat('dd/MM/yyyy - hh:mm a').format(timestamp);

        String senderName = currentUser.displayName ?? '';
        String result = senderName.substring(0, senderName.indexOf('@'));

        await docRef.update({
          "messages": FieldValue.arrayUnion([
            "$result:$text \n $datetime"
          ]), // Including timestamp in the message
        });
        messageController.clear();
      } else {
        // Handle case where the message is empty
        // You can show a snackbar, toast, or any other UI indication to the user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a non-empty message')),
        );
      }
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
                              const ls = LineSplitter();
                              final sampleTextLines =
                                  ls.convert(snapshot.data[index]);

                              if (sampleTextLines.length > 1) {
                                return ListTile(
                                  title: Text(" ${sampleTextLines[0]}"),
                                  subtitle: Text(" ${sampleTextLines[1]}"),
                                );
                              } else {
                                return ListTile(
                                  title: Text(" ${sampleTextLines[0]}"),
                                );
                              }
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
