import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _displayName = '';
  String _profileImage = '';

  String get displayName => _displayName;
  String get profileImage => _profileImage;

  void updateUser(String newName, String newProfileImage) {
    _displayName = newName;
    _profileImage = newProfileImage;
    notifyListeners();
  }
}
