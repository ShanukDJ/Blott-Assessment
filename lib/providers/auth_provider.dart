import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServiceProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;

  User? get user => _user;

  bool get isAuthenticated => _user != null;

  AuthServiceProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    _user = await _authService.getCurrentUser();
    notifyListeners();
  }

  Future<void> signUp(String firstName, String lastName) async {
    try {
      _user = await _authService.signUp(firstName, lastName);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }
}
