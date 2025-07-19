import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mileage_calculator/models/mileage_model.dart';

class MileageProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addHistory(MileageModel record) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection("users")
        .doc(user.uid)
        .collection("history")
        .add({
          ...record.toMap(),
          "timestamp": FieldValue.serverTimestamp(), // for ordering
        });
  }

  Stream<QuerySnapshot> getHistoryStream() {
    final user = _auth.currentUser;
    if (user == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection("users")
        .doc(user.uid)
        .collection("history")
        .orderBy("timestamp", descending: true)
        .snapshots();
  }
}
