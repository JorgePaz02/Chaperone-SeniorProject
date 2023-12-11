import 'package:app/UserInfo/groupmodel.dart';
import 'package:app/screens/group_created_screen.dart';
import 'package:flutter/material.dart';

class CreateGroupScreen extends StatefulWidget {
  CreateGroupScreen({Key? key}) : super(key: key);

  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final groupname = TextEditingController();
  int number = 0;
  bool isMaxMembersSelected = false; // Track if max members have been selected
  bool isGroupNameEntered = false; // Track if group name has been entered

  final List<int> maxMembersOptions = List.generate(19, (index) => index + 2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/CreateGroup.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "", //removal of fun about to begin
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
                  onChanged: (_) {
                    setState(() {
                      isGroupNameEntered = groupname.text.isNotEmpty;
                    });
                  },
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
                    labelText: "Max Members",
                    border: OutlineInputBorder(),
                  ),
                  value: null,
                  items: maxMembersOptions.map((value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      number = newValue!;
                      isMaxMembersSelected = true; // Set selection flag
                    });
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                width: 200.0,
                height: 60.0,
                child: ElevatedButton(
                  onPressed: isMaxMembersSelected && isGroupNameEntered
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => groupcreated(
                                name: groupname.text,
                                passcode: number,
                              ),
                            ),
                          );
                        }
                      : null, // Disable button if requirements are not met
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: const Text(
                    "Create Group",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  String getText() {
    return groupname.text;
  }
}
