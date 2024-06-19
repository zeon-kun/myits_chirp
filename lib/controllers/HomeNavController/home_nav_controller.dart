import 'package:flutter/material.dart';

class HomeNavController with ChangeNotifier {
  int _currentScreenIndex = 0;
  bool _isDetailScreen = false;
  bool _isFollowerScreen = false;
  String? _detailScreenId;

  int get currentScreenIndex => _currentScreenIndex;
  bool get isDetailScreen => _isDetailScreen;
  bool get isFollowerScreen => _isFollowerScreen;
  String? get detailScreenId => _detailScreenId;

  void setCurrentScreenIndex(int index) {
    _currentScreenIndex = index;
    _isDetailScreen = false;
    _isFollowerScreen = false;
    _detailScreenId = null;
    notifyListeners();
  }

  void showDetailScreen(String spaceId) {
    _isDetailScreen = true;
    _isFollowerScreen = false; // Reset follower screen flag
    _detailScreenId = spaceId;
    notifyListeners();
  }

  void showFollowerScreen(String spaceId) {
    _isFollowerScreen = true;
    _isDetailScreen = false; // Reset detail screen flag
    _detailScreenId = spaceId;
    notifyListeners();
  }

  void hideDetailScreen() {
    _isDetailScreen = false;
    _isFollowerScreen = false;
    _detailScreenId = null;
    notifyListeners();
  }
}
