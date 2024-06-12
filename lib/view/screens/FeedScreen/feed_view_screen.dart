import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
// import 'package:wave/view/screens/FeedScreen/feed_post_screen.dart';

import '../../../data/feed_provider.dart';
import '../../../utils/routing.dart';

class FeedViewScreen extends StatefulWidget {
  const FeedViewScreen ({super.key});

  @override
  State<FeedViewScreen> createState() => _FeedViewScreenState();
}

class _FeedViewScreenState extends State<FeedViewScreen> {

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My ITS Chirp Stories'),
        backgroundColor: Colors.blue[800],
      ),
      body: FutureBuilder(
        future: Provider.of<StoryProvider>(context, listen: false).fetchAndSetStories(),
        builder: (ctx, snapshot) =>
        snapshot.connectionState == ConnectionState.waiting
            ? Center(child: CircularProgressIndicator())
            : Consumer<StoryProvider>(
          builder: (ctx, storyProvider, _) => GridView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: storyProvider.stories.length,
            itemBuilder: (ctx, i) => GridTile(
              child: Image.file(File(storyProvider.stories[i].imagePath)),
              footer: GridTileBar(
                backgroundColor: Colors.black54,
                title: Text(storyProvider.stories[i].title),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.comment),
                      onPressed: () {
                        Get.toNamed(AppRoutes.listCommentsScreen);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        Provider.of<StoryProvider>(context, listen: false)
                            .deleteStory(storyProvider.stories[i].id);
                      },
                    ),
                  ],
                ),
              ),
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
          ),
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          Get.toNamed(AppRoutes.feedPostScreen);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
