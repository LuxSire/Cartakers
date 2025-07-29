import 'package:flutter/material.dart';

/// Available roles
enum UserRole { admin, manager, user }

class AuthService with ChangeNotifier {
  UserRole? _userRole; // Stores the current user role

  UserRole? get userRole => _userRole;

  /// Set the user role after login
  void setRole(UserRole role) {
    _userRole = role;
    notifyListeners();
  }

  /// Check if the user has access to a feature
  bool hasAccess(List<UserRole> allowedRoles) {
    return _userRole != null && allowedRoles.contains(_userRole);
  }
}
