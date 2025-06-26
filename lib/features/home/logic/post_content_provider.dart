import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodbook_beta/features/home/data/model/post_model.dart';

class PostContentNotifier extends StateNotifier<List<PostContent>> {
  PostContentNotifier() : super([]);

  void addImage(File image, {String? recipe}) {
    state = [...state, PostContent(image: image, recipe: recipe)];
  }

  void addVideo(File video, {String? recipe}) {
    state = [...state, PostContent(video: video, recipe: recipe)];
  }

  void clearAll() {
    state = [];
  }

  void removeAt(int index) {
    final updated = [...state]..removeAt(index);
    state = updated;
  }

  void updateRecipe(int index, String recipe) {
    if (index < 0 || index >= state.length) return;
    final updated = [...state];
    final item = updated[index];
    updated[index] = PostContent(
      image: item.image,
      video: item.video,
      recipe: recipe,
    );
    state = updated;
  }
}

final postContentProvider =
    StateNotifierProvider<PostContentNotifier, List<PostContent>>(
      (ref) => PostContentNotifier(),
    );
