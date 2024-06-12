// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:wave/services/space_services.dart';

// class SpaceScreen extends StatefulWidget {
//   @override
//   State<SpaceScreen> createState() => _SpaceScreenState();
// }

// class _SpaceScreenState extends State<SpaceScreen> {
//   final SpaceService _spaceService = SpaceService();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _descController = TextEditingController();

//   void _showDialog({String? spaceId, String? spaceName, String? spaceDesc}) {
//     if (spaceId != null) {
//       _nameController.text = spaceName!;
//       _descController.text = spaceDesc!;
//     } else {
//       _nameController.clear();
//       _descController.clear();
//     }

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(spaceId == null ? 'Create Space' : 'Edit Space'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(labelText: 'Space Name'),
//               ),
//               TextField(
//                 controller: _descController,
//                 decoration: const InputDecoration(labelText: 'Space Description'),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 if (spaceId == null) {
//                   _spaceService.addSpace(_nameController.text, _descController.text);
//                 } else {
//                   _spaceService.updateSpace(spaceId, _nameController.text, _descController.text);
//                 }
//                 Navigator.pop(context);
//               },
//               child: Text(spaceId == null ? 'Create' : 'Update'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Spaces'),
//         backgroundColor: Colors.blue[900],
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _spaceService.getSpaceStream(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData) {
//             return const Center(child: Text('No Spaces Available'));
//           }

//           return ListView.builder(
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (context, index) {
//               var space = snapshot.data!.docs[index];
//               return ListTile(
//                 title: Text(space['space']),
//                 subtitle: Text(space['space_desc']),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.edit),
//                       onPressed: () => _showDialog(
//                         spaceId: space.id,
//                         spaceName: space['space'],
//                         spaceDesc: space['space_desc'],
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.delete),
//                       onPressed: () => _spaceService.deleteSpace(space.id),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _showDialog(),
//         backgroundColor: Colors.blue[900],
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }