import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Chat>> getChats() {
    return _db
        .collection('chats')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Chat.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }
}

class Chat {
  final String name;
  final String lastMessage;
  final Timestamp timestamp;

  Chat(
      {required this.name, required this.lastMessage, required this.timestamp});

  factory Chat.fromMap(Map<String, dynamic> data) {
    return Chat(
      name: data['name'] ?? '',
      lastMessage: data['lastMessage'] ?? '',
      timestamp: data['timestamp'],
    );
  }
}
