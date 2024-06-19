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

  Future<List<QueryDocumentSnapshot>> checkIfChatExists(
      String otherUserId, String userId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('chats')
        .where('participant', arrayContains: otherUserId)
        .get();

    // Filter the results to include only those that also contain `userId`
    List<QueryDocumentSnapshot> filteredChats = querySnapshot.docs.where((doc) {
      List<dynamic> participants = doc['participant'];
      return participants.contains(userId);
    }).toList();

    return filteredChats;
  }

  Future<void> deleteChat(String chatId) async {
    // Deleting the chat document and all its subcollections (messages)
    WriteBatch batch = FirebaseFirestore.instance.batch();

    // Reference to the chat document
    DocumentReference chatDocRef =
        FirebaseFirestore.instance.collection('chats').doc(chatId);

    // Adding the deletion of the chat document to the batch
    batch.delete(chatDocRef);

    // Deleting all messages in the chat
    QuerySnapshot messagesSnapshot =
        await chatDocRef.collection('messages').get();
    for (DocumentSnapshot doc in messagesSnapshot.docs) {
      batch.delete(doc.reference);
    }

    // Committing the batch
    await batch.commit();
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
