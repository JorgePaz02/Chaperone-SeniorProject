import 'package:app/UserInfo/QuitGroupReset.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

String? groupcode = "";


class GroupScreen extends StatefulWidget {
  const GroupScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GroupScreen();
  }
}

 bool check = false;

class _GroupScreen extends State<GroupScreen> {
  

  @override
  Widget build(BuildContext context) {
    String? user = "";
   
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: FutureBuilder<String>(
            future: groupName(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.toString(),
                    style: const TextStyle(color: Colors.black));
              }
              return const Text('');
            }),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: 2, // Two columns
          padding: const EdgeInsets.all(16.0),
          mainAxisSpacing: 16.0, // Spacing between rows
          crossAxisSpacing: 16.0, // Spacing between columns
          children: <Widget>[
            _buildCircularButton(
                Icons.announcement, "Announcements", Colors.blue, () {
              Navigator.pushNamed(context, '/announceScreen');

              print("Announcements button tapped");
            }),
            _buildCircularButton(Icons.message, "Messages", Colors.green, () {
              // Add functionality for Messages button here
              Navigator.pushNamed(context, "/messageScreen");
            }),
            _buildCircularButton(Icons.health_and_safety, "Safety", Colors.red,
                () {
              // Add functionality for Safety button here
              print("Safety button tapped");
            }),
            _buildCircularButton(Icons.mail, "Invitations", Colors.orange, () {
              // Add functionality for Invitations button here
              print("Invitations button tapped");
            }),
            _buildCircularButton(Icons.group, "Member List", Colors.purple, () {
              // Add functionality for Member List button here
              print("Member List button tapped");
            }),
            _buildCircularButton(Icons.settings, "Options", Colors.teal, () {
              // Add functionality for Options button here
              print("Options button tapped");
            }),
            _buildCircularButton(
              Icons.crisis_alert,
              "QUIT GROUP",
              const Color.fromARGB(255, 255, 8, 0),
              () {
                checkifLeader();

                Future.delayed(const Duration(milliseconds: 500), () {
                if (check != true) {
               
                  user = auth.currentUser!.displayName;
                  quitGroup(user!);
                } else {
                 
                  userReset(groupcode!);
                }
                });
                
                Future.delayed(const Duration(milliseconds: 3000), () {
                  Navigator.pushNamed(context, "/home");
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
      onTap:
          onPressed, // Use the provided onPressed callback for individual functionality
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
