import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RadiusUpdateDialog {
  static Future<void> show(BuildContext context) async {
    TextEditingController radiusController = TextEditingController();

    bool isTextFieldEmpty() {
      return radiusController.text.trim().isEmpty;
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Radius Update'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: radiusController,
                  decoration: InputDecoration(
                    labelText: 'Enter new radius',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isTextFieldEmpty()
                      ? null
                      : () {
                          int newRadius =
                              int.tryParse(radiusController.text) ?? 0;
                          updateRadius(newRadius);
                          Navigator.pop(context); // Close the dialog after update
                        },
                  child: Text('Update'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> updateRadius(int X) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final db = FirebaseFirestore.instance;

    try {
      DocumentSnapshot userDoc = await db
          .collection("Users")
          .doc(auth.currentUser!.displayName)
          .get();
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
}
