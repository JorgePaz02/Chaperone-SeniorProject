import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/UserInfo/groupmodel.dart';

Future<void> groupSetup(String groupname, int num, String passcode) async {
  CollectionReference group = FirebaseFirestore.instance.collection('Groups');

  group.add(
      {'groupname': groupname, 'number of members': num, 'passcode': passcode});
}
