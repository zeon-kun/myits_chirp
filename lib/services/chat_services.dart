import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Chat>> getChats() {
    return _db
        .collection('chats')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                Chat.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Future<void> addChat(String name, String lastMessage) async {
    await _db.collection('chats').add({
      'name': name,
      'lastMessage': lastMessage,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}

class Chat {
  final String id;
  final String name;
  final String lastMessage;
  final Timestamp timestamp;

  Chat(
      {required this.id,
      required this.name,
      required this.lastMessage,
      required this.timestamp});

  factory Chat.fromMap(Map<String, dynamic> data, String id) {
    return Chat(
      id: id,
      name: data['name'] ?? '',
      lastMessage: data['lastMessage'] ?? '',
      timestamp: data['timestamp'],
    );
  }
}
