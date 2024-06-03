import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wave/services/chat_services.dart'; // Assume this imports the ChatService and Chat classes

class ChatListScreen extends StatelessWidget {
  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat List'),
      ),
      body: StreamBuilder<List<Chat>>(
        stream: _chatService.getChats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No chats available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Chat chat = snapshot.data![index];
                return ListTile(
                  leading: FlutterLogo(),
                  title: Text(chat.name),
                  subtitle: Text(chat.lastMessage),
                  trailing: Text(_formatTimestamp(chat.timestamp)),
                  onTap: () {
                    // Handle chat item tap
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return '${date.hour}:${date.minute}';
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(home: ChatListScreen()));
}
