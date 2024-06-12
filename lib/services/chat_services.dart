import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Chat>> getChats(String userId) {
    return _db
        .collection('chats')
        .where('participant', arrayContains: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                Chat.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Future<void> addChat(String name, String participant1, String participant2,
      String lastMessage) async {
    await _db.collection('chats').add({
      'name': name,
      'participant': {participant1, participant2},
      'lastMessage': lastMessage,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<QuerySnapshot> checkIfChatExists(String otherUserId) {
    return _db
        .collection('chats')
        .where('participant', arrayContains: otherUserId)
        .get();
  }
}

class Chat {
  final String id;
  final String name;
  final List<String> participant;
  final String lastMessage;
  final Timestamp timestamp;

  Chat({
    required this.id,
    required this.name,
    required this.participant,
    required this.lastMessage,
    required this.timestamp,
  });

  factory Chat.fromMap(Map<String, dynamic> data, String id) {
    var participants =
        List<String>.from(data['participant']); // Cast to List<String>
    return Chat(
      id: id,
      name: data['name'] ?? '',
      participant: participants,
      lastMessage: data['lastMessage'] ?? '',
      timestamp: data['timestamp'],
    );
  }
}
