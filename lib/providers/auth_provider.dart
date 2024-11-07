
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  AuthProvider() {
    _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  User? get user => _user;

  Future<void> signUpAnonymously() async {
    try {
      await _auth.signInAnonymously();
    } catch (e) {
      print("Error signing in anonymously: $e");
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}