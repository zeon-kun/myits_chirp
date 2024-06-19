import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../../services/space_services.dart';
import '../../../models/space_model.dart';
import 'space_form.dart';
import 'space_detail_screen.dart';
import 'package:wave/controllers/HomeNavController/home_nav_controller.dart';

class SpaceListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spaces'),
        backgroundColor: Colors.blue[900],
      ),
      body: Consumer<SpaceService>(
        builder: (context, spaceService, child) {
          return StreamBuilder<QuerySnapshot>(
            stream: spaceService.getSpaceStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData) {
                return const Center(child: Text('No Spaces Available'));
              }

              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var space = snapshot.data!.docs[index];
                  return ListTile(
                    title: Text(space['space']),
                    subtitle: Text(space['space_desc']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SpaceFormScreen(
                                space: Space.fromDocument(space),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => spaceService.deleteSpace(space.id),
                        ),
                      ],
                    ),
                    onTap: () {
                      Provider.of<HomeNavController>(context, listen: false)
                          .showDetailScreen(space.id);
                    },
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SpaceFormScreen(),
          ),
        ),
        backgroundColor: Colors.blue[900],
        child: const Icon(Icons.add),
      ),
    );
  }
}
