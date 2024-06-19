import 'package:cloud_firestore/cloud_firestore.dart';

class Space {
  final String id;
  final String name;
  final String description;
  final List<String> followers; // Ensure followers is of type List<String>

  Space({
    required this.id,
    required this.name,
    required this.description,
    required this.followers,
  });

  factory Space.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Space(
      id: doc.id,
      name: data['space'] ?? '',
      description: data['space_desc'] ?? '',
      followers: List<String>.from(data['followers'] ?? []), // Ensure followers is parsed as List<String>
    );
  }
}
