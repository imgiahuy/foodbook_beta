import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostContent {
  final File? image;
  final File? video;

  PostContent({this.image, this.video});
}

class PostContentNotifier extends StateNotifier<PostContent?> {
  PostContentNotifier() : super(null);

  void setImage(File image) => state = PostContent(image: image, video: null);

  void setVideo(File video) => state = PostContent(image: null, video: video);

  void clear() => state = null;
}

final postContentProvider =
    StateNotifierProvider<PostContentNotifier, PostContent?>(
      (ref) => PostContentNotifier(),
    );
