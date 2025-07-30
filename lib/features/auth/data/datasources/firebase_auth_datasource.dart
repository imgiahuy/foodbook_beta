import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../dtos/user_model.dart';

class FirebaseAuthDatasource {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _mapFirebaseUserWithProfile(
    fb.User fbUser,
    Map<String, dynamic>? profile,
  ) {
    return UserModel.fromFirebaseUser(fbUser, username: profile?['username']);
  }

  UserModel? get currentUser {
    final fbUser = _auth.currentUser;
    if (fbUser != null) {
      return UserModel.fromFirebaseUser(fbUser);
    }
    return null;
  }

  Future<UserModel?> signIn(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final fb.User? fbUser = result.user;
    if (fbUser != null) {
      final profileDoc = await _firestore
          .collection('users')
          .doc(fbUser.uid)
          .get();
      final profileData = profileDoc.data();
      return _mapFirebaseUserWithProfile(fbUser, profileData);
    }
    return null;
  }

  Future<UserModel?> signUp(
    String email,
    String password,
    String username,
  ) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final fb.User? fbUser = result.user;
    if (fbUser != null) {
      await _firestore.collection('users').doc(fbUser.uid).set({
        'username': username,
        'email': email,
      });
      return UserModel.fromFirebaseUser(fbUser, username: username);
    }
    return null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
