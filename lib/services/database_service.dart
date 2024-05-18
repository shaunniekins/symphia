// database_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:symphia/models/user_profile.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get UID of currently logged in user
  String? get currentUid => _auth.currentUser?.uid;

  // Create user
  Future<void> createUser(UserProfile user) async {
    await _db.collection('users').doc(currentUid).set(user.toMap());
  }

  // Read user
  Stream<UserProfile?> getUser() {
    return _db.collection('users').doc(currentUid).snapshots().map((doc) {
      return doc.exists
          ? UserProfile.fromMap(doc.data() as Map<String, dynamic>)
          : null;
    });
  }

  // Update user
  Future<void> updateUser(UserProfile user) async {
    await _db.collection('users').doc(currentUid).update(user.toMap());
  }

  // Delete user
  Future<void> deleteUser() async {
    await _db.collection('users').doc(currentUid).delete();
  }

  // Query data
  Stream<List<UserProfile>> queryUsersByUid() {
    return _db
        .collection('users')
        .where('uid', isEqualTo: currentUid)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return UserProfile.fromMap(doc.data());
      }).toList();
    });
  }
}
