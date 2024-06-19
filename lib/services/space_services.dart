import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/space_model.dart';

class SpaceService {
  final CollectionReference spaces = FirebaseFirestore.instance.collection('spaces');

  Future<void> addSpace(String spaceName, String spaceDescription) async {
    try {
      await spaces.add({
        'space': spaceName,
        'space_desc': spaceDescription,
        'timestamp': Timestamp.now(),
        'followers': [], // Initialize followers as an empty array
      });
    } catch (e) {
      throw Exception('Failed to add space: $e');
    }
  }

  Stream<QuerySnapshot> getSpaceStream() {
    return spaces.orderBy('timestamp', descending: true).snapshots();
  }

  Future<void> updateSpace(String spaceId, String newSpaceName, String newSpaceDescription) async {
    try {
      await spaces.doc(spaceId).update({
        'space': newSpaceName,
        'space_desc': newSpaceDescription,
        'timestamp': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to update space: $e');
    }
  }

  Future<void> deleteSpace(String spaceId) async {
    try {
      await spaces.doc(spaceId).delete();
    } catch (e) {
      throw Exception('Failed to delete space: $e');
    }
  }

  Future<Space> getSpaceById(String spaceId) async {
    try {
      DocumentSnapshot doc = await spaces.doc(spaceId).get();
      if (doc.exists) {
        return Space.fromDocument(doc);
      } else {
        throw Exception('Space not found');
      }
    } catch (e) {
      throw Exception('Failed to get space: $e');
    }
  }

  Future<void> followSpace(String spaceId, String userId) async {
    try {
      await spaces.doc(spaceId).update({
        'followers': FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      throw Exception('Failed to follow space: $e');
    }
  }

  Future<void> unfollowSpace(String spaceId, String userId) async {
    try {
      await spaces.doc(spaceId).update({
        'followers': FieldValue.arrayRemove([userId]),
      });
    } catch (e) {
      throw Exception('Failed to unfollow space: $e');
    }
  }
}
