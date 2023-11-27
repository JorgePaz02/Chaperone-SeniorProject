import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;

class MemberLocation {
  final String memberName;
  final GeoPoint location;

  MemberLocation(this.memberName, this.location);
}



Future<List<MemberLocation>> getGroupMembersWithLocations(String passcode) async {
  try {
    DocumentSnapshot groupSnapshot =
        await db.collection('Groups').doc(passcode).get();

    if (groupSnapshot.exists) {
      Map<String, dynamic> groupData =
          groupSnapshot.data() as Map<String, dynamic>;

      List<String> memberDisplayNames =
          List<String>.from(groupData['members'] ?? []);

      List<MemberLocation> memberLocations = [];

      for (String displayName in memberDisplayNames) {
        DocumentSnapshot userSnapshot =
            await db.collection('Users').doc(displayName).get();

        if (userSnapshot.exists) {
          Map<String, dynamic> userData =
              userSnapshot.data() as Map<String, dynamic>;

          GeoPoint? userPosition = userData['position'] as GeoPoint?;
          if (userPosition != null) {
            memberLocations.add(MemberLocation(displayName, userPosition));
          }
        }
      }

      return memberLocations;
    } else {
      throw ('Group with ID $passcode does not exist');
    }
  } catch (e) {
    print('Error fetching group members\' locations: $e');
    return []; // Return an empty list or handle the error accordingly
  }
}

void printMemberLocations(List<MemberLocation> memberLocations) {
  for (var memberLocation in memberLocations) {
    print(
        'Member: ${memberLocation.memberName}, Location: ${memberLocation.location.latitude}, ${memberLocation.location.longitude}');
  }
}

