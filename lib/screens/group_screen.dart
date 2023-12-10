import 'package:app/UserInfo/QuitGroupReset.dart';
import 'package:app/UserInfo/getUserLocation.dart';
import 'package:app/UserInfo/distanceComparison.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async'; // Import dart:async for Timer

String? groupcode = "";
  
class GroupScreen extends StatefulWidget {
  @override
  _GroupScreenState createState() => _GroupScreenState();
}

  bool check = false;
    
class _GroupScreenState extends State<GroupScreen> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    startFetchingMemberLocations(context);
  }

  @override
  void dispose() {
    timer.cancel(); // Cancel the timer to prevent memory leaks when the widget is disposed
    super.dispose();
  }

  Future<String> getGroupPasscode() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      String currentUserDisplayName = auth.currentUser!.displayName!;

      DocumentSnapshot userSnapshot = await db.collection('Users').doc(currentUserDisplayName).get();

      if (userSnapshot.exists) {
        String groupPasscode = userSnapshot.get('group');
        return groupPasscode;
      } else {
        throw ('User data not found');
      }
    } catch (e) {
      print('Error fetching group passcode: $e');
      return ''; // Return an empty string or handle the error accordingly
    }
  }
   Future<int> getRadius() async {
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
            return value2.get('radius');
          });
      });
    }

Future<List<MemberLocation>> fetchGroupMembersWithLocations(String passcode) async {
  try {
    List<MemberLocation> membersWithLocations = await getGroupMembersWithLocations(passcode);
    return membersWithLocations;
  } catch (e) {
    print('Error fetching group members\' locations: $e');
    return [];
  }
}
void startFetchingMemberLocations(BuildContext context) {
  const duration = Duration(seconds: 5); // Change this to your desired interval
  timer = Timer.periodic(duration, (Timer t) async {
    String passcode = await getGroupPasscode();
    int radius = await getRadius();
    if (passcode.isNotEmpty) {
      List<MemberLocation> membersWithLocations = await fetchGroupMembersWithLocations(passcode);
      if (membersWithLocations.isNotEmpty) {
        printMemberLocations(membersWithLocations);
        checkUserDistances(context, membersWithLocations, radius); // Pass BuildContext here
      } else {
        print('No member locations found.');
      }
    } else {
      print('Failed to retrieve group passcode.');
    }
  });
}





    final FirebaseAuth auth = FirebaseAuth.instance;
    Future<String> groupName() async {
      return await FirebaseFirestore.instance
          .collection('Users')
          .doc(auth.currentUser!.displayName)
          .get()
          .then((value) async {
        groupcode = value.get('group');
        return await FirebaseFirestore.instance
            .collection('Groups')
            .doc(value.get('group'))
            .get()
            .then((value2) {
          return value2.get('groupname');
        });
      });
    }

    Future<void> checkifLeader() async {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final db = FirebaseFirestore.instance;
      db
          .collection('Users')
          .doc(auth.currentUser!.displayName)
          .get()
          .then((value) async {
        if (value.get("group leader") == true) {
          setState(() {
             
            check = true;
          });
          
         
        } else {
          setState(() {
                        
            check = false;
          });
          
          
        }
      });
    }

    Future<void> quitGroup(String user) async {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final db = FirebaseFirestore.instance;
      db.collection("Users").doc(user).get().then((value) async {
        String passcode = value.get("group");
        final docRef = db.collection("Groups").doc(passcode);
        docRef.update({
          "members": FieldValue.arrayRemove([auth.currentUser!.displayName]),
        });
        final docRef2 =
            db.collection("Users").doc(auth.currentUser!.displayName);
        docRef2.update({
          "group": "",
          "group leader": false,
        });
      });
    }

  @override
  Widget build(BuildContext context) {
    String? user = "";
    return Scaffold(
     appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: const SizedBox.shrink(),
        title: FutureBuilder<String>(
          future: groupName(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              return Text(
                "${snapshot.data.toString()}: ${groupcode}",
                style: const TextStyle(
                  color: Colors.black,
                )
              );
            }
            return const Text('');
          }
        ),
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(16.0),
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          children: <Widget>[
            _buildCircularButton(Icons.announcement, "Announcements", Colors.blue, () {
              Navigator.pushNamed(context, '/announceScreen');
            }),
            _buildCircularButton(Icons.access_time, "Itinerary", Colors.green, () {
              // Add functionality for Messages button here
              Navigator.pushNamed(context, "/itineraryScreen");
            }),
            _buildCircularButton(Icons.message, "Messages", Colors.green, () {
              Navigator.pushNamed(context, "/messageScreen");
            }),
            _buildCircularButton(Icons.health_and_safety, "Safety", Colors.red, () {
              print("Safety button tapped");
            }),
            _buildCircularButton(Icons.group, "Member List", Colors.purple, () async {
              Navigator.pushNamed(context, "/membersScreen");

              String passcode = await getGroupPasscode();
              if (passcode.isNotEmpty) {
                fetchGroupMembersWithLocations(passcode);
              } else {
                print('Failed to retrieve group passcode.');
              }
            }),
            _buildCircularButton(Icons.settings, "Options", Colors.teal, () {
              Navigator.pushNamed(context, '/radius_update');
              print("Options button tapped");
            }),
            _buildCircularButton(
              Icons.crisis_alert,
              "QUIT GROUP",
              const Color.fromARGB(255, 255, 8, 0),
              () {
                checkifLeader();
                Future.delayed(const Duration(milliseconds: 500), () {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Quitting?'),
                      content: Text(
                        check ?
                        'If you quit, the entire group will be deleted! Are you sure you want to quit?'
                        :
                        'If you quit, you will no longer participate in this group! Are you sure you want to quit?'
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            if (check) {
                              userReset(groupcode!);
                            } else {
                              user = auth.currentUser!.displayName;
                              quitGroup(user!);
                            }
                            Future.delayed(
                              const Duration(milliseconds: 3000), () {
                                Navigator.pushNamed(context, "/home");
                              }
                            );
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                });
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCircularButton(
      IconData icon, String label, Color color, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 30.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 36.0,
                color: color,
              ),
              const SizedBox(height: 8.0),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}