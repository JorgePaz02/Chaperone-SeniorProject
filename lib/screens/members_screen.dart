import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MembersScreen extends StatelessWidget {
  const MembersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;

    Future<dynamic> listMembers() async {
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
          return value2.get('members');
        });
      });
    }

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
              Icons.group,
              color: Colors.purple
            ),
            SizedBox(
              width: 10
            ),
            Text(
              'Members List',
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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[200], // Light gray background color
              //borderRadius: borderRadius2,
            ),
            child: FutureBuilder<dynamic>(
                future: listMembers(),
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
                            title: Text((index + 1).toString() +
                                '. ' +
                                snapshot.data[index]),
                          );
                        },
                      );
                    }
                    else {
                      return const Text('How is this possible...?');
                    }
                  }
                  return const Text('');
                }),
          ),
        ],
      ),
    );
  }
}
