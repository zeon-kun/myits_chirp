import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wave/controllers/PostController/feed_post_controller.dart';
import 'package:wave/utils/constants/custom_colors.dart';
import 'package:intl/intl.dart';
import 'package:wave/models/post_model.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../utils/constants/custom_icons.dart';
import '../../../utils/device_size.dart';
import '../../../utils/routing.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.primaryBackGround,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Implement refresh logic if needed
          },
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: CustomColor.primaryBackGround,
                title: Text(
                  "MyITS Chirp",
                  style: TextStyle(fontFamily: CustomFont.alex, fontSize: 40),
                ),
                floating: true,
                snap: true,
                elevation: 0,
                actions: [
                  // Add actions if needed
                ],
              ),
              SliverToBoxAdapter(
                child: Consumer<FeedPostController>(
                  builder: (context, feedController, child) {
                    return StreamBuilder<QuerySnapshot>(
                      stream: feedController.getPostsStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text("Error: ${snapshot.error}"));
                        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(child: Text("No posts available"));
                        } else {
                          List<Post> posts = snapshot.data!.docs.map((doc) => Post.fromMap(doc.data() as Map<String, dynamic>)).toList();

                          return Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 14.0, right: 8, top: 2),

                                height: displayHeight(context) * 0.12,
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(

                                      child: InkWell(
                                        onTap: () {

                                        },
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Get.toNamed(AppRoutes.feedPostScreen);
                                                // Navigator.pushNamed(context,
                                                //     FeedPostScreen.routeName);
                                              },
                                              child: CircleAvatar(
                                                backgroundColor: Colors.transparent,
                                                radius: 30,
                                                backgroundImage:
                                                AssetImage(CustomIcon.addStoryIcon),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 2,
                                            ),
                                            Text(
                                              "You",
                                              style: TextStyle(
                                                  fontFamily: CustomFont.poppins, fontSize: 10),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        padding: const EdgeInsets.symmetric(horizontal: 4),
                                        itemCount: 10,
                                        itemBuilder: (BuildContext context, int index) {
                                          return Padding(
                                            padding:
                                            const EdgeInsets.symmetric(horizontal: 6.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Get.toNamed(AppRoutes.feedViewScreen);
                                                  },
                                                  child: CircleAvatar(
                                                    radius: 30,
                                                    backgroundColor: Colors.blue.shade100,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 2,
                                                ),
                                                Text(
                                                  "alpha3109",
                                                  style: TextStyle(
                                                      fontFamily: CustomFont.poppins,
                                                      fontSize: 10),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: posts.length,
                                itemBuilder: (context, index) {
                                  final post = posts[index];

                                  return FutureBuilder<String?>(
                                    future: feedController.getUserName(post.userId),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return ListTile(
                                          title: Text(post.caption),
                                          subtitle: Text("Loading..."),
                                        );
                                      } else if (snapshot.hasError || !snapshot.hasData) {
                                        return ListTile(
                                          title: Text(post.caption),
                                          subtitle: Text("Unknown User"),
                                        );
                                      } else {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Card(
                                            child: ListTile(
                                              title: Text(post.caption),
                                              subtitle: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(snapshot.data!), // Display user name
                                                  Text(
                                                    DateFormat.yMMMMd().add_jm().format(post.createdAt),
                                                  ),
                                                  FutureBuilder<bool>(
                                                    future: feedController.isUserPost(post.id, FirebaseAuth.instance.currentUser!.uid),
                                                    builder: (context, userPostSnapshot) {
                                                      if (userPostSnapshot.connectionState == ConnectionState.waiting) {
                                                        return CircularProgressIndicator();
                                                      } else if (userPostSnapshot.data == true) {
                                                        return IconButton(
                                                          onPressed: () {
                                                            showDialog(
                                                              context: context,
                                                              builder: (BuildContext context) {
                                                                return AlertDialog(
                                                                  title: Text("Konfirmasi"),
                                                                  content: Text("Apakah Anda yakin ingin menghapus post?"),
                                                                  actions: <Widget>[
                                                                    TextButton(
                                                                      child: Text("No"),
                                                                      onPressed: () {
                                                                        Navigator.of(context).pop();
                                                                      },
                                                                    ),
                                                                    TextButton(
                                                                      child: Text("Yes"),
                                                                      onPressed: () {
                                                                        feedController.deletePost(post.id);
                                                                        Navigator.of(context).pop();
                                                                      },
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          },
                                                          icon: const Icon(Icons.delete),
                                                        );
                                                      } else {
                                                        return SizedBox.shrink(); // Return an empty widget if not the user's post
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  );

                                },
                              ),
                            ],
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
