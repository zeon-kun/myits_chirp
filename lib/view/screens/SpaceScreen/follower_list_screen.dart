import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wave/models/user_model.dart';

class FollowerListScreen extends StatelessWidget {
  final String spaceId;

  const FollowerListScreen({required this.spaceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Followers'),
      ),
      body: StreamBuilder<List<String>>(
        stream: FirebaseFirestore.instance
            .collection('spaces')
            .doc(spaceId)
            .snapshots()
            .map((snapshot) => List<String>.from(snapshot['followers'])),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final followerIds = snapshot.data!;
          if (followerIds.isEmpty) {
            return Center(
              child: Text('No followers'),
            );
          }

          return ListView.builder(
            itemCount: followerIds.length,
            itemBuilder: (context, index) {
              return FutureBuilder<User>(
                future: _getUserProfile(followerIds[index]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(
                      leading: CircularProgressIndicator(),
                      title: Text('Loading...'),
                    );
                  }
                  if (snapshot.hasError) {
                    return ListTile(
                      title: Text('Error loading follower'),
                    );
                  }
                  final follower = snapshot.data!;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: follower.displayPicture != null
                          ? NetworkImage(follower.displayPicture!)
                          : null,
                    ),
                    title: Text(follower.name),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<User> _getUserProfile(String userId) async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return User.fromMap(userDoc.data()!);
  }
}
