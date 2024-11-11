
import 'package:flutter/material.dart';



class AuthProvider extends ChangeNotifier {
  String? _firstName;
  String? _lastName;

  String? get firstName => _firstName;
  String? get lastName => _lastName;

  void setUserData(String firstName, String lastName) {
    _firstName = firstName;
    _lastName = lastName;
    notifyListeners();
  }

  void clearUserData() {
    _firstName = null;
    _lastName = null;
    notifyListeners();
  }
}
