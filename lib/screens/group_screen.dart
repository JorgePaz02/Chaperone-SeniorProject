import 'package:app/UserInfo/QuitGroupReset.dart';
import 'package:app/UserInfo/geolocator.dart';
import 'package:app/UserInfo/getUserLocation.dart';
import 'package:app/UserInfo/distanceComparison.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async'; // Import dart:async for Timer

String? groupcode = "";
  
class GroupScreen extends StatefulWidget {
  const GroupScreen({Key? key}) : super(key: key);

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
    getLocationUpdates();
    startFetchingMemberLocations(context);
        

  }

  @override
  void dispose() {
    timer.cancel(); // Cancel the timer to prevent memory leaks when the widget is disposed
    super.dispose();
  }

  void getLocationUpdates() async{
  final FirebaseAuth auth = FirebaseAuth.instance;
      String currentUserDisplayName = auth.currentUser!.displayName!;
              startLocationUpdates(currentUserDisplayName);
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
  try {
    final DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser!.displayName)
        .get();

    if (userSnapshot.exists) {
      final group = userSnapshot.get('group');
      final DocumentSnapshot groupSnapshot = await FirebaseFirestore.instance
          .collection('Groups')
          .doc(group)
          .get();

      if (groupSnapshot.exists) {
        return groupSnapshot.get('radius');
      } else {
        throw ('Group data not found');
      }
    } else {
      throw ('User data not found');
    }
  } catch (e) {
    print('Error fetching radius: $e');
    return 0; // Return a default value or handle the error accordingly
  }
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
  const duration = Duration(seconds: 120);

  timer = Timer.periodic(duration, (Timer t) async {
    String passcode = await getGroupPasscode();
    int radius = await getRadius();
    if (passcode.isNotEmpty) {
      List<MemberLocation> membersWithLocations = await fetchGroupMembersWithLocations(passcode);
      if (membersWithLocations.isNotEmpty) {
        printMemberLocations(membersWithLocations);
        checkUserDistances(context, membersWithLocations, radius);
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
  if (this.mounted) {
    try {
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
      }).catchError((error) {
        print('Error fetching data: $error');
        throw error;
      });
    } catch (e) {
      print('Error in groupName function: $e');
      throw e;
    }
  }
  // Return a default value or handle the case where the widget is not mounted
  return ''; // Replace with appropriate handling or default value
}


  Future<void> checkifLeader() async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  db
    .collection('Users')
    .doc(auth.currentUser!.displayName)
    .get()
    .then((value) async {
      if (this.mounted) {
        if (value.get("group leader") == true) {
          setState(() {
            check = true;
          });
        } else {
          setState(() {
            check = false;
          });
        }
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
    String? user = "";
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Disable back button functionality
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/assets/WidgetScreen.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      SizedBox(height: MediaQuery.of(context).padding.top),
                      SizedBox(height: kToolbarHeight),
                      GridView.count(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        padding: const EdgeInsets.all(16.0),
                        mainAxisSpacing: 80.0,
                        crossAxisSpacing: 32.0,
                        children: <Widget>[
                          _buildCircularButton(Icons.announcement, "Announcements", Colors.blue, () {
                            Navigator.pushNamed(context, '/announceScreen');
                          }),
                          _buildCircularButton(Icons.access_time, "Itinerary", Colors.pink, () {
                            Navigator.pushNamed(context, "/itineraryScreen");
                          }),
                          _buildCircularButton(Icons.message, "Messages", Colors.green, () {
                            Navigator.pushNamed(context, "/messageScreen");
                          }),
                          _buildCircularButton(Icons.map, "Map", Colors.indigo, () {
                            Navigator.pushNamed(context, '/groupMapScreen');
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
                                      check
                                          ? 'If you quit, the entire group will be deleted! Are you sure you want to quit?'
                                          : 'If you quit, you will no longer participate in this group! Are you sure you want to quit?',
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
                                            const Duration(milliseconds: 3000),
                                            () {
                                              Navigator.pushNamed(context, "/home");
                                            },
                                          );
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: const SizedBox.shrink(),
                title: FutureBuilder<String>(
                  future: groupName(),
                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        "${snapshot.data.toString()}: $groupcode",
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularButton(IconData icon, String label, Color color, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2.0),
        ),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
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