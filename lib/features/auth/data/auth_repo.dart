import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/app_users.dart';

class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<AppUsers> register({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final firebaseUser = credential.user!;

    // Every public registration creates a normal user.
    final userData = {
      'email': firebaseUser.email,
      'role': 'user',
      'createdAt': FieldValue.serverTimestamp(),
    };

    await _firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .set(userData);

    return AppUsers(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? email,
      role: 'user',
    );
  }

  Future<AppUsers> login({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final firebaseUser = credential.user!;

    final userDocument = await _firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .get();

    if (!userDocument.exists) {
      await _auth.signOut();
      throw Exception('User profile was not found.');
    }

    return AppUsers.fromMap(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? email,
      data: userDocument.data()!,
    );
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<AppUsers?> getCurrentUser() async {
    final firebaseUser = _auth.currentUser;

    if (firebaseUser == null) {
      return null;
    }

    final userDocument = await _firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .get();

    if (!userDocument.exists) {
      await _auth.signOut();
      return null;
    }

    return AppUsers.fromMap(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      data: userDocument.data()!,
    );
  }
}