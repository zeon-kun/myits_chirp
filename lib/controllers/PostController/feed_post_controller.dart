import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wave/utils/enums.dart';

class FeedPostController extends ChangeNotifier {
  // List<Post> posts = [];
  POSTS_STATE postState = POSTS_STATE.ABSENT;
  int currentPostLimit = 100;
  DocumentSnapshot? lastDocument;

  final CollectionReference postsCollection = FirebaseFirestore.instance.collection('posts');
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  Stream<QuerySnapshot> getPostsStream() {

      return postsCollection
        .orderBy('createdAt', descending: true)
        .snapshots();

  }

  Future<String?> getUserName(String userId) async {
    try {
      var userDoc = await usersCollection.doc(userId).get();
      if (userDoc.exists) {
        return userDoc['name'];
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting user name: $e');
      return null;
    }
  }

  Future<void> deletePost(String userId) async{
    return postsCollection.doc(userId).delete();
  }

  Future<bool> isUserPost(String postid, String userId) async{

      DocumentSnapshot postSnapshot = await postsCollection.doc(postid).get();
      if (postSnapshot.exists) {
        Map<String, dynamic> postData = postSnapshot.data() as Map<String, dynamic>;
        if (postData['userId'] == userId) {
          return true;
        }
      }
      return false;

  }

}
