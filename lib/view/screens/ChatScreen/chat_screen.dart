import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatelessWidget {
  final String chatId;
  final String chatName;

  ChatScreen({required this.chatId, required this.chatName});

  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chatName),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var messages = snapshot.data!.docs;

          return ListView.builder(
            reverse: true,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              var message = messages[index];
              var timestamp = message['timestamp'] as Timestamp?;
              bool isMe = message['sender'] == userId;

              return Align(
                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  decoration: BoxDecoration(
                    color: isMe ? Colors.blue[100] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message['text'],
                        style: TextStyle(
                          color: isMe ? Colors.black : Colors.black87,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        _formatTimestamp(timestamp),
                        style: TextStyle(
                          color: isMe ? Colors.black : Colors.black54,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Enter message...',
                ),
                onSubmitted: (text) {
                  if (text.isNotEmpty) {
                    _sendMessage(text);
                  }
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                // Add functionality to send a message
              },
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage(String text) async {
    var messageRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc();

    var message = {
      'sender': userId,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    };

    var chatRef = FirebaseFirestore.instance.collection('chats').doc(chatId);

    // Perform the write operations in a batch
    var batch = FirebaseFirestore.instance.batch();

    batch.set(messageRef, message);
    batch.update(chatRef, {
      'lastMessage': text,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) {
      return 'Sending...'; // Placeholder text while the timestamp is being set
    }
    DateTime date = timestamp.toDate();
    return '${date.hour}:${date.minute}';
  }
}
