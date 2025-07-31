import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodbook_beta/features/auth/presentation/states/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/models/user.dart';

class ProfileController {
  final WidgetRef ref;
  ProfileController(this.ref);

  Future<void> signOut(BuildContext context) async {
    try {
      await ref.read(authNotifierProvider.notifier).signOut();
      context.goNamed('welcome');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Logout failed: $e')));
    }
  }

  User? readAuthState() {
    return ref.read(authNotifierProvider).value;
  }

  Future<void> pickAndUploadAvatar(BuildContext context) async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;

      final file = File(pickedFile.path);
      final notifier = ref.read(authNotifierProvider.notifier);

      // Update avatar in user profile
      await notifier.updateAvatar(file);

      // Refresh user state
      final user = await notifier.getCurrentUserUseCase();
      notifier.state = AsyncValue.data(user);

      if (user != null && user.avatar != null) {
        await _updatePostsAvatar(user.username, user.avatar!);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Avatar updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update avatar: $e')));
    }
  }

  
  Future<void> _updatePostsAvatar(String? username, String newAvatarUrl) async {
    if (username == null) return;

    final firestore = FirebaseFirestore.instance;
    final postsRef = firestore.collection('posts');

    final snapshot = await postsRef
        .where('username', isEqualTo: username)
        .get();

    for (var doc in snapshot.docs) {
      await postsRef.doc(doc.id).update({'avatarUrl': newAvatarUrl});
    }
  }
}
