import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodbook_beta/features/auth/domain/models/auth_repository.dart';
import 'package:foodbook_beta/features/posten/domain/model/post.dart';
import 'package:foodbook_beta/features/posten/domain/model/post_repository.dart';
import 'package:image_picker/image_picker.dart';

class PostController extends ChangeNotifier {
  final PostRepository _postRepository;
  final AuthRepository _authRepository;

  PostController(this._postRepository, this._authRepository);

  File? image;
  String recipe = "";

  final List<PostContent> posts = [];

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      notifyListeners();
    }
  }

  void clearDraft() {
    image = null;
    recipe = "";
    notifyListeners();
  }

  void setRecipe(String text) {
    recipe = text;
    notifyListeners();
  }

  Future<void> loadPosts() async {
    posts.clear();
    final allPosts = await (_postRepository as dynamic).loadAllRemote();
    posts.addAll(allPosts);
    notifyListeners();
  }

  Future<PostContent> postContent() async {
    final user = await _authRepository.getCurrentUser();
    if (user == null) {
      throw Exception('No logged in user');
    }
    final newPost = PostContent(
      username: user.username,
      postid: DateTime.now().millisecondsSinceEpoch.toString(),
      image: image?.path,
      avatarUrl: user.avatar,
      recipe: recipe,
      liked: false,
    );

    await _postRepository.saveRemote(newPost, imageFile: image);

    // Re-fetch all posts after saving
    await loadPosts();

    clearDraft();
    return newPost;
  }
}
