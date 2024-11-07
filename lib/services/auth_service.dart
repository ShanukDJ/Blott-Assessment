import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<User?> signUp(String firstName, String lastName) async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      User? user = userCredential.user;

      // Store the first and last name in firestore
      if (user != null) {
        await _fireStore.collection('users').doc(user.uid).set({
          'firstName': firstName,
          'lastName': lastName,
        });
      }

      return user;
    } on FirebaseAuthException catch (e) {
      rethrow;
    }
  }

  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
