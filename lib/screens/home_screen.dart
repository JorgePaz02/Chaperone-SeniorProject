import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    void checkGroup() {
      FirebaseFirestore.instance
          .collection('Users')
          .doc(auth.currentUser!.displayName)
          .get()
          .then(
        (value) {
          if (value.get('group') != "") {
            Navigator.pushNamed(context, '/groupScreen');
          }
        },
      );
    }

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

    checkGroup();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Navigator.pushNamed(context, '/home');
          },
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
            image:
                AssetImage('lib/assets/JoinOrAdd.png'), // Update the image path
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
                    "", //removal of wywtdt
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                      height: 20.0), // Add spacing between text and buttons
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
                              backgroundColor: Colors
                                  .blue, // Background color of the circle button
                              child: Padding(
                                padding: EdgeInsets.all(8.0), // Add padding
                                child: Icon(Icons.list, size: 48.0),
                              ),
                            ),
                          ),
                          const SizedBox(
                              height:
                                  10.0), // Add spacing between text and button
                          const Text(
                            "Create Group",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                          width: 80.0), // Add spacing between buttons
                      Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/joinGroup');
                            },
                            child: const CircleAvatar(
                              radius: 60.0,
                              backgroundColor: Colors
                                  .green, // Background color of the circle button
                              child: Padding(
                                padding: EdgeInsets.all(8.0), // Add padding
                                child: Icon(Icons.sensor_door_outlined,
                                    size: 48.0),
                              ),
                            ),
                          ),
                          const SizedBox(
                              height:
                                  10.0), // Add spacing between text and button
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
    );
  }
}
