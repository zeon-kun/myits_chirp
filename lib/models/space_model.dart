import 'package:cloud_firestore/cloud_firestore.dart';

class Space {
  String id;
  String name;
  String description;
  List<String> followers; // Change to List<String>
  Timestamp timestamp;

  Space({
    required this.id,
    required this.name,
    required this.description,
    required this.followers,
    required this.timestamp,
  });

  factory Space.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Space(
      id: doc.id,
      name: data['space'] ?? '',
      description: data['space_desc'] ?? '',
      followers: List<String>.from(data['followers']), // Change to List<String>
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'space': name,
      'space_desc': description,
      'followers': followers,
      'timestamp': timestamp,
    };
  }
}
