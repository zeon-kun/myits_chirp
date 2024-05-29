import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MyITS Chirp",
          style: TextStyle(color:Colors.white, fontSize: 24),
        ),
        backgroundColor: Colors.blue[900],
      ),
      floatingActionButton: FloatingActionButton(
      onPressed: (){},
      child:const Icon(Icons.add_circle_outline),
          backgroundColor: Colors.white,
      ),
    );
  }
}
