import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/space_model.dart';

class SpaceService {
  final CollectionReference spaces = FirebaseFirestore.instance.collection('spaces');

  Future<void> addSpace(String spaceName, String spaceDescription) {
    return spaces.add({
      'space': spaceName,
      'space_desc': spaceDescription,
      'timestamp': Timestamp.now(),
      'followers': 0, // Initial followers count
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

  Future<Space> getSpaceById(String spaceId) async {
    DocumentSnapshot doc = await spaces.doc(spaceId).get();
    if (doc.exists) {
      return Space.fromDocument(doc);
    } else {
      throw Exception('Space not found');
    }
  }

    Future<void> followSpace(String spaceId, String userId) async {
    await spaces.doc(spaceId).update({
      'followers': FieldValue.arrayUnion([userId]),
    });
  }

  Future<void> unfollowSpace(String spaceId, String userId) async {
    await spaces.doc(spaceId).update({
      'followers': FieldValue.arrayRemove([userId]),
    });
  }
}
