import 'package:app/UserInfo/getUserLocation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class GroupScreen extends StatelessWidget {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  GroupScreen({Key? key}) : super(key: key);

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

  void fetchGroupMembersWithLocations(String passcode) async {
    try {
      List<MemberLocation> membersWithLocations = await getGroupMembersWithLocations(passcode);
      
      if (membersWithLocations.isNotEmpty) {
        printMemberLocations(membersWithLocations);
      } else {
        print('No member locations found.');
      }
    } catch (e) {
      print('Error fetching group members\' locations: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Group Name', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
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
              print("Announcements button tapped");
            }),
            _buildCircularButton(Icons.access_time, "Itinerary", Colors.green, () {
              // Add functionality for Messages button here
              Navigator.pushNamed(context, "/itineraryScreen");
            }),
            // _buildCircularButton(Icons.message, "Messages", Colors.green, () {
            //   Navigator.pushNamed(context, "/messageScreen");
            // }),
            _buildCircularButton(Icons.health_and_safety, "Safety", Colors.red, () {
              print("Safety button tapped");
            }),
            _buildCircularButton(Icons.mail, "Invitations", Colors.orange, () {
              print("Invitations button tapped");
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
