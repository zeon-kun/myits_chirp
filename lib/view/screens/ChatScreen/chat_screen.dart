import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  final String chatId;
  final String chatName;

  ChatScreen({required this.chatId, required this.chatName});

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
              return ListTile(
                title: Text(message['text']),
                subtitle: Text(_formatTimestamp(timestamp)),
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

  void _sendMessage(String text) {
    FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) {
      return 'Sending...'; // Placeholder text while the timestamp is being set
    }
    DateTime date = timestamp.toDate();
    return '${date.hour}:${date.minute}';
  }
}
