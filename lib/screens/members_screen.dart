import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({Key? key}) : super(key: key);

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;

    Future<bool> isLeader(user) async {
      return await FirebaseFirestore.instance
        .collection('Users')
        .doc(user)
        .get()
        .then(
          (value) async {
            return value.get("group leader");
          }
        );
    }

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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Row(
          children: [
            Icon(
              Icons.group,
              color: Colors.white
            ),
            SizedBox(
              width: 10
            ),
            Text(
              'Members List',
              style: TextStyle(
                color: Colors.white
              )
            ),
          ],
        ),
      ),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FutureBuilder<dynamic>(
                future: listMembers(),
                builder: (BuildContext context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const CircularProgressIndicator();
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
                                    // DateTime timestamp = snapshot.data[index]['date_time'].toDate();
                                    // String datetime = DateFormat('dd/MM/yyyy, hh:mm a').format(timestamp);
                                    return Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: const BorderSide(
                                          color: Colors.grey),
                                          bottom: BorderSide(
                                            color:
                                            index < snapshot.data.length - 1
                                            ?
                                            Colors.transparent
                                            :
                                            Colors.grey
                                          ),
                                        ),
                                        color:
                                        index % 2 == 0 
                                        ? 
                                        Colors.grey[100]
                                        : 
                                        Colors.grey[200],
                                      ),
                                      child: Row(children: <Widget>[
                                        Container(
                                          padding: const EdgeInsets.all(4.0),
                                          child: FutureBuilder<dynamic>(
                                            future: isLeader(snapshot.data[index]['name']),
                                            builder: (BuildContext context,snapshot) {
                                              switch (snapshot.connectionState) {
                                                case ConnectionState.waiting:
                                                  return const CircularProgressIndicator();
                                                default:
                                                  if (snapshot.hasError) {
                                                    return Text(
                                                      'Error: ${snapshot.error}',
                                                      style: const TextStyle(
                                                        color: Colors.red,
                                                      ),
                                                    );
                                                  }
                                                  else {
                                                    if (snapshot.hasData) {
                                                      if (snapshot.data) {
                                                        return const Icon(
                                                          Icons.person_4_rounded,
                                                          color: Colors.black,
                                                        );
                                                      }
                                                    }
                                                  }
                                              }
                                              return const SizedBox.shrink();
                                            },
                                          ),
                                        ),
                                        Container(
                                          constraints: const BoxConstraints(
                                          maxWidth: double.infinity,
                                        ),
                                        child: Column(children: <Widget>[
                                          TextButton(
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                '${index + 1}. ${snapshot.data[index]['name']}',
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold
                                                )
                                              ),
                                            ),
                                            onPressed: () {
                                              showDialog<String>(
                                                context: context,
                                                builder: (BuildContext context) => AlertDialog(
                                                  title: Text(snapshot.data[index]['name']),
                                                  content: FutureBuilder<dynamic>(
                                                    future: isLeader(snapshot.data[index]['name']),
                                                    builder: (BuildContext context,snapshot) {
                                                      switch (snapshot.connectionState) {
                                                        case ConnectionState.waiting:
                                                          return const CircularProgressIndicator();
                                                        default:
                                                          if (snapshot.hasError) {
                                                            return Text(
                                                              'Error: ${snapshot.error}',
                                                              style: const TextStyle(
                                                                color: Colors.red,
                                                              ),
                                                            );
                                                          }
                                                          else {
                                                            if (snapshot.hasData) {
                                                              return Text((snapshot.data ? 'They are a leader of your group!' : ''));
                                                            }
                                                          }
                                                      }
                                                      return const SizedBox.shrink();
                                                    },
                                                  ),
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
                                      child: Container(),
                                    ),
                                  ]
                                ),
                              );
                            }
                          )
                          );
                          } else {
                            return Container(
                              child:
                                  const Text('Huh? How did this happen...'),
                              padding: const EdgeInsets.all(16.0),
                            );
                          }
                        }
                      }
                  }
                  return const SizedBox.shrink();
                }
              ),
          ],
        ),
      ),
    );
  }
}
