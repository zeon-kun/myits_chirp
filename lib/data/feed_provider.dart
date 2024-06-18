import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/feed_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoryProvider with ChangeNotifier {
  List<StoryItem> _stories = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<StoryItem> get stories => [..._stories];

  Future<void> fetchAndSetStoriesPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('stories')) {
      final extractedData = json.decode(prefs.getString('stories')!) as List<
          dynamic>;
      final List<StoryItem> loadedStories = extractedData.map((item) =>
          StoryItem.fromJson(item)).toList();
      _stories = loadedStories;
      notifyListeners();
    }

  }
  Future<void> fetchAndSetStories() async {
    final snapshot = await _firestore.collection('stories').get();
    final List<StoryItem> firestoreStories = snapshot.docs.map((doc) {
      // final imageBytes = await _image!.readAsBytes();
      // final imageString = base64Encode(imageBytes);
      // final imageBytes =  base64Decode(doc.data()["getImage"]);
      // final image = Image.memory(imageBytes);

      // doc.data()["imagePath"] = image;
      return StoryItem.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();
    _stories = firestoreStories;
    notifyListeners();
  }

  Future<void> addStory(StoryItem story) async {
    _stories.add(story);
    await _saveToPrefs();
    await _firestore.collection('stories').add(story.toJson());
    notifyListeners();
  }

  Future<void> updateStory(String id, StoryItem newStory) async {
    final storyIndex = _stories.indexWhere((story) => story.id == id);
    if (storyIndex >= 0) {
      _stories[storyIndex] = newStory;
      await _saveToPrefs();
      await _firestore.collection('stories').doc(id).update(newStory.toJson());
      notifyListeners();
    }
  }

  Future<void> deleteStory(String id) async {
    _stories.removeWhere((story) => story.id == id);
    await _saveToPrefs();
    await _firestore.collection('stories').doc(id).delete();
    notifyListeners();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final storyData = _stories.map((story) => story.toJson()).toList();
    prefs.setString('stories', json.encode(storyData));
  }

}