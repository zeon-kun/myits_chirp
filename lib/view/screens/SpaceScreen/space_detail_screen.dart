import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/space_services.dart';
import '../../../models/space_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wave/controllers/HomeNavController/home_nav_controller.dart';

class SpaceDetailScreen extends StatefulWidget {
  final String spaceId;

  SpaceDetailScreen({required this.spaceId});

  @override
  _SpaceDetailScreenState createState() => _SpaceDetailScreenState();
}

class _SpaceDetailScreenState extends State<SpaceDetailScreen> {
  late String _userId;

  @override
  void initState() {
    super.initState();
    _userId = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    final _spaceService = Provider.of<SpaceService>(context, listen: false);
    final _spaceFuture = _spaceService.getSpaceById(widget.spaceId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Space Detail'),
        backgroundColor: Colors.blue[900],
      ),
      body: FutureBuilder<Space>(
        future: _spaceFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            debugPrint('Error: ${snapshot.error}');
            return const Center(child: Text('Error loading space'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Space not found'));
          }

          var space = snapshot.data!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(space.name, style: Theme.of(context).textTheme.headlineLarge),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(space.description),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Followers: ${space.followers.length}'), // Update to display the actual number of followers
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _spaceService.followSpace(space.id, _userId);
                      },
                      child: const Text('Follow'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        _spaceService.unfollowSpace(space.id, _userId);
                      },
                      child: const Text('Unfollow'),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.read<HomeNavController>().showFollowerScreen(space.id);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Icon(Icons.people),
                      const SizedBox(width: 8),
                      Text(
                        'Followers',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    // List of posts related to the space
                    // This part needs to be implemented based on your post model and service
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
