import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/firestore.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override


  final FirestoreService firestoreService = FirestoreService();

  final TextEditingController TextController = TextEditingController();


  void openPostBox({String? docID}){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: TextController,
        ),
        actions: [
          ElevatedButton(
              onPressed: () {
                if(docID == null){
                  firestoreService.addPost(TextController.text);
                } else{
                  // firestoreService.updateNote(docID, TextController.text);
                }

                TextController.clear();

                Navigator.pop(context);
              },
              child: const Text("Add")
          )
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MyITS Chirp",
          style: TextStyle(color:Colors.white, fontSize: 24),
        ),
        backgroundColor: Colors.blue[900],
      ),
      floatingActionButton: FloatingActionButton(
      onPressed: openPostBox,
      child:const Icon(Icons.add_circle_outline),
          backgroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(

        stream: firestoreService.getPostsStream(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            List postsList = snapshot.data!.docs;

            return ListView.builder(
                itemCount: postsList.length,
                itemBuilder: (context, index){
                  DocumentSnapshot document = postsList[index];
                  String docID = document.id;

                  Map<String, dynamic> data =
                  document.data() as Map<String,  dynamic>;
                  String postText = data['post'];
                  // String timeStamp =data['timestamp'];
                  DateTime dateTime = data['timestamp'].toDate();
                  String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(dateTime);

                  return ListTile(
                      title: Text(postText),
                      subtitle: Text(formattedDate),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,


                        children: [
                        //   //update
                        //   IconButton(
                        //     onPressed: ()=> openPostBox(docID: docID),
                        //     icon: const Icon(Icons.edit),
                        //   ),
                        //
                        //   //delete
                          IconButton(
                            onPressed: () => firestoreService.deletePost(docID),
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      )
                  );
                }
            );
          }

          else{
            return const Text("No New Posts..");
          }
        },
      ),
    );
  }

  text(String s) {}
}
