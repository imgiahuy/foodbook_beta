import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodbook_beta/features/posten/domain/model/post.dart';
import 'package:image_picker/image_picker.dart';

class PostController extends ChangeNotifier {
  File? image;
  File? video;
  String recipe = "";

  final List<PostContent> posts = [];

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      video = null;
      notifyListeners();
    }
  }

  Future<void> pickVideo() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      video = File(pickedFile.path);
      image = null;
      notifyListeners();
    }
  }

  void clearDraft() {
    image = null;
    video = null;
    recipe = "";
    notifyListeners();
  }

  void setRecipe(String text) {
    recipe = text;
    notifyListeners();
  }

  Future<PostContent> postContent() async {
    final newPost = PostContent(
      username: "someUserId",
      postid: DateTime.now().millisecondsSinceEpoch.toString(),
      image: image?.path,
      video: video?.path,
      recipe: recipe,
      liked: false,
    );
    posts.insert(0, newPost);
    clearDraft();
    notifyListeners();
    return newPost;
  }
}
