import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodbook_beta/features/posten/logic/post_content_provider.dart';
import 'package:foodbook_beta/features/posten/data/model/post_model.dart';

final likedPostsProvider = Provider<List<PostContent>>((ref) {
  final allPosts = ref.watch(postContentProvider);
  return allPosts.where((post) => post.liked == true).toList();
});
