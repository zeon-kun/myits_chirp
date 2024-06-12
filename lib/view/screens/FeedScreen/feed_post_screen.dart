import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../data/feed_provider.dart';
import '../../../models/feed_item.dart';

class FeedPostScreen extends StatefulWidget {
  const FeedPostScreen ({super.key});

  @override
  State<FeedPostScreen> createState() => _FeedPostScreenState();
}

class _FeedPostScreenState extends State<FeedPostScreen> {
  final _formKey = GlobalKey<FormState>();
  var _editedStory = StoryItem(id: '', imagePath: '', title: '', image: '');
  File? _image;
  final picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  void _takeImage(){
    _pickImage(ImageSource.camera);
  }

  void _openImage(){
    _pickImage(ImageSource.gallery);
  }

  void _storeForm() async{
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    try {
      final imageBytes = await _image!.readAsBytes();
      final imageString = base64Encode(imageBytes);
      final newStory = StoryItem(
        id: DateTime.now().toString(),
        imagePath: _image!.path,
        title: _editedStory.title,
        image: imageString,
      );
      Provider.of<StoryProvider>(context, listen: false).addStory(newStory);
    } catch (e){
      print(e);
    }
    Navigator.of(context).pop();
  }

  void _saveForm(){
    _storeForm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Story'),
        backgroundColor: Colors.blue[800],
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            color: Colors.white70,
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onSaved: (value) {
                  _editedStory = StoryItem(
                    id: _editedStory.id,
                    imagePath: _editedStory.imagePath,
                    title: value!, image: '',
                  );
                },
              ),
              SizedBox(height: 20),
              Row(
                children: <Widget>[
                  _image == null
                      ? Text('No Image Selected')
                      : Image.file(
                    _image!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  TextButton(
                    child: Text('Choose Image'),
                    onPressed: _openImage,
                  ),
                  TextButton(
                    child: Text('Take Image'),
                    onPressed: _takeImage,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
