import 'package:cloud_firestore/cloud_firestore.dart';


Future<void> groupSetup(String groupname, int num, String passcode, displayName, int radius) async {
  final db = FirebaseFirestore.instance;
  CollectionReference group = db.collection('Groups');
  var announcements = [];
  var itinerary = [];

  final data = <String, dynamic>{
    "groupname": groupname,
    "number of members": num,
    "passcode": passcode,
    "members": [displayName],
    "announcements": announcements,
    'itinerary': itinerary,
    "radius": radius, // Add the radius to the group data
  };

  final docRef2 = db.collection("Users").doc(displayName);
  docRef2.update({
    "group leader": true,
  });

  await group.doc(passcode).set(data);
}



Future<List<DocumentSnapshot>> getGroupMembersLocations(String groupId) async {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  try {
    QuerySnapshot querySnapshot = await db
        .collection('Groups')
        .doc(groupId)
        .collection('locations')
        .get();

    // Return a list of documents (representing each member's location)
    return querySnapshot.docs;
  } catch (e) {
    print('Error fetching group members locations: $e');
    return []; // Return an empty list or handle the error accordingly
  }
}
