import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mileage_calculator/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final Logger _logger = Logger();

  User? _firebaseUser;
  Map<String, dynamic>? _userData;
  bool _isLoading = false;

  User? get firebaseUser => _firebaseUser;
  Map<String, dynamic>? get userData => _userData;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _auth.authStateChanges().listen(onAuthStateChanged);
  }

  Future<void> onAuthStateChanged(User? user) async {
    _firebaseUser = user;
    if (user != null) {
      _isLoading = true;
      notifyListeners();
      await fetchUserData(user.uid);
    } else {
      _userData = null;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchUserData(String uid) async {
    final doc = await _fireStore.collection("users").doc(uid).get();
    _userData = doc.data();
  }

  Future<void> signUp(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    try {
      _isLoading = true;
      notifyListeners();

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;

      UserModel newUser = UserModel(
        uid: uid,
        email: email,
        firstName: firstName,
        lastName: lastName,
      );

      await _fireStore.collection("users").doc(uid).set({
        ...newUser.toMap(),
        "timestamp": FieldValue.serverTimestamp(),
      });
    } on FirebaseAuthException catch (e) {
      _logger.e("Firebase error: ${e.code} - ${e.message}");
      throw Exception("Failed to register: ${e.message}");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      _logger.e("Firebase error: ${e.code} - ${e.message}");
      throw Exception("Failed to login: ${e.message}");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      _isLoading = true;
      notifyListeners();

      await _auth.signOut();
    } catch (e) {
      _logger.e("Sign out failed: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
