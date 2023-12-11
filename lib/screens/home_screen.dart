import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final FirebaseAuth auth = FirebaseAuth.instance;
  
Future<void> _showLogoutDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Log Out'),
        content: Text('Are you sure you want to log out?'),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Log Out'),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, '/mainscreen'); // Navigate to the MainScreen after logout
            },
          ),
        ],
      );
    },
  );
}
  @override
Widget build(BuildContext context) {
  // Function to check if the user belongs to a group and navigate accordingly
  void checkGroup() {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser!.displayName)
        .get()
        .then(
      (value) {
        if (value.get('group') != "") {
          Navigator.pushReplacementNamed(context, '/groupScreen');
        }
      },
    );
  }

  // Function to fetch the user's display name
  Future<String> getName() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(auth.currentUser!.displayName)
        .get()
        .then(
      (value) async {
        return auth.currentUser!.displayName.toString();
      },
    );
  }

  // Calling the checkGroup function
  checkGroup();

  return WillPopScope(
    onWillPop: () async {
      return false; // Disable backtracking
    },
    child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            _showLogoutDialog(context);
          },
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Icon(
              Icons.person,
              color: Colors.purple,
              size: 45.0,
            ),
          ),
        ),
        title: FutureBuilder<String>(
          future: getName(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              return Text('Hello, ${snapshot.data}',
                  style: const TextStyle(color: Colors.black));
            }
            return const Text('');
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/JoinOrAdd.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/createGroup');
                            },
                            child: const CircleAvatar(
                              radius: 60.0,
                              backgroundColor: Colors.blue,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.list, size: 48.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          const Text(
                            "Create Group",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 80.0),
                      Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/joinGroup');
                            },
                            child: const CircleAvatar(
                              radius: 60.0,
                              backgroundColor: Colors.green,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.sensor_door_outlined,
                                    size: 48.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          const Text(
                            "Join Group",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}