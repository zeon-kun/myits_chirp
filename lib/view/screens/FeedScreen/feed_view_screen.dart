import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/feed_provider.dart';

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
        title: Text('Instagram Stories'),
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
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    Provider.of<StoryProvider>(context, listen: false)
                        .deleteStory(storyProvider.stories[i].id);
                  },
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.of(context).pushNamed(FeedViewScreen.routeName);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
