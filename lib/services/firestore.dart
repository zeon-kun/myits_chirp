import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService{
  final CollectionReference posts =
  FirebaseFirestore.instance.collection('posts');

  Future<void> addPost(String post) {
    return posts.add({
      'post': post,
      'timestamp': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getPostsStream(){
    final postsStream =
    posts.orderBy('timestamp', descending: true).snapshots();

    return postsStream;
  }

  Future<void> deletePost(String docID){
    return posts.doc(docID).delete();
  }

}