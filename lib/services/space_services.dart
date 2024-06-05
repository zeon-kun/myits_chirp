import 'package:cloud_firestore/cloud_firestore.dart';

class SpaceService {
  final CollectionReference spaces = FirebaseFirestore.instance.collection('spaces');

  Future<void> addSpace(String spaceName, String spaceDescription) {
    return spaces.add({
      'space': spaceName,
      'space_desc': spaceDescription,
      'timestamp': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getSpaceStream() {
    return spaces.orderBy('timestamp', descending: true).snapshots();
  }

  Future<void> updateSpace(String spaceId, String newSpaceName, String newSpaceDescription) {
    return spaces.doc(spaceId).update({
      'space': newSpaceName,
      'space_desc': newSpaceDescription,
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> deleteSpace(String spaceId) {
    return spaces.doc(spaceId).delete();
  }
}