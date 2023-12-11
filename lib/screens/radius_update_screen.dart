import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RadiusUpdateScreen extends StatelessWidget {
  const RadiusUpdateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController radiusController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Radius Update'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'lib/assets/RadiusUpdate.png', // Make sure to adjust the path
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextField(
                  controller: radiusController,
                  decoration: InputDecoration(
                    labelText: 'Enter new radius',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  // Add controller to capture input.
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Get the value from the TextField and convert it to an integer
                    int newRadius = int.tryParse(radiusController.text) ?? 0;
                    updateRadius(newRadius); // Call updateRadius function
                  },
                  child: Text('Update'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> updateRadius(int X) async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  try {
    DocumentSnapshot userDoc =
        await db.collection("Users").doc(auth.currentUser!.displayName).get();
    String passcode = userDoc.get("group");
    DocumentReference docRef = db.collection("Groups").doc(passcode);
    await docRef.update({
      "radius": X,
    });
    print("Radius updated successfully!");
  } catch (e) {
    print("Error updating radius: $e");
    // Handle error as needed
  }
}
