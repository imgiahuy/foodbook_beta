import 'dart:io';
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

    await loadPosts();

    clearDraft();
    return newPost;
  }

  Future<void> toggleLike(PostContent post) async {
    // Toggle liked state
    final updatedPost = PostContent(
      username: post.username,
      postid: post.postid,
      image: post.image,
      recipe: post.recipe,
      avatarUrl: post.avatarUrl,
      liked: !post.liked,
    );

    if (updatedPost.liked) {
      // Save locally when liked
      await _postRepository.saveLocal(updatedPost);
    } else {
      // Delete locally when unliked
      await _postRepository.deleteLocal(updatedPost.postid!);
    }

    // Update in list and notify UI
    final index = posts.indexWhere((p) => p.postid == post.postid);
    if (index != -1) {
      posts[index] = updatedPost;
      notifyListeners();
    }
  }

  Future<String?> getCurrentUsername() async {
    final user = await _authRepository.getCurrentUser();
    return user?.username;
  }
}
