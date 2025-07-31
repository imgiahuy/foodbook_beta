import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:foodbook_beta/features/posten/data/datasource/cloudinary_service.dart';
import '../dtos/user_model.dart';

class FirebaseAuthDatasource {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CloudinaryService cloudinaryService;

  FirebaseAuthDatasource(this.cloudinaryService);

  UserModel? _mapFirebaseUserWithProfile(
    fb.User fbUser,
    Map<String, dynamic>? profile,
  ) {
    return UserModel.fromFirebaseUser(
      fbUser,
      username: profile?['username'],
      avatar: profile?['avatar'],
    );
  }

  Future<UserModel?> get currentUser async {
    final fbUser = _auth.currentUser;
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
    File? avatarFile, // add avatarFile parameter
  ) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final fb.User? fbUser = result.user;
    if (fbUser != null) {
      String? avatarUrl;

      // If avatarFile is provided, upload it and get URL
      if (avatarFile != null) {
        avatarUrl = await cloudinaryService.uploadImage(avatarFile);
      }

      // Save user info + avatar URL to Firestore
      await _firestore.collection('users').doc(fbUser.uid).set({
        'username': username,
        'email': email,
        if (avatarUrl != null) 'avatar': avatarUrl, // only add if exists
      });

      return UserModel.fromFirebaseUser(
        fbUser,
        username: username,
        avatar: avatarUrl,
      );
    }
    return null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> updateAvatar(File avatarFile) async {
    final fb.User? fbUser = _auth.currentUser;
    if (fbUser == null) throw Exception("No logged-in user");

    final avatarUrl = await cloudinaryService.uploadImage(avatarFile);

    await _firestore.collection('users').doc(fbUser.uid).update({
      'avatar': avatarUrl,
    });
  }
}
