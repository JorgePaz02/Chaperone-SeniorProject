// ignore_for_file: prefer_const_constructors

import 'package:app/UserInfo/groupmodel.dart';
import 'package:app/group_created_screen.dart';
import 'package:flutter/material.dart';

class CreateGroupScreen extends StatelessWidget {
   final groupname = TextEditingController();
   int number = 0;
  CreateGroupScreen({Key? key}) : super(key: key);
  final List<int> maxMembersOptions =
      List.generate(19, (index) => index + 2); // Generate values from 2 to 20


  @override
  Widget build(BuildContext context) {
 


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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "The fun is about to begin!",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: groupname,
                decoration: InputDecoration(
                  labelText: "Group Name",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: "Max Members", ////////////////NOT COMPLETE
                  border: OutlineInputBorder(),
                ),

                value: null, // Initially no value is selected
                items: maxMembersOptions.map((value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                onChanged: (newValue) {
                  number = newValue!.toInt();
                  // Handle the dropdown value change here
                },
              ),
            ),
            const SizedBox(
                height: 20.0), // Add spacing between dropdown and button
            SizedBox(
              width: 200.0, // Set the desired width for the button
              height: 60.0, // Set the desired height for the button
              child: ElevatedButton(
                onPressed: () {
                  //////////FIX VARIABLES

                  //Navigator.pushNamed(context, '/groupCreated');
                   Navigator.push(context,
        MaterialPageRoute(
          builder: (context) => new groupcreated(name: groupname.text, passcode: number)));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.black, // Set the button background color to black
                ),
                child: const Text(
                  "Create Group",
                  style: TextStyle(
                    fontSize: 18.0, // Set the font size for the button text
                    color: Colors.white, // Set the text color to white
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getText() {
     return groupname.text;
  }
}
