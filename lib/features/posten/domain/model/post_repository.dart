import 'dart:io';

import 'package:foodbook_beta/features/posten/domain/model/post.dart';

abstract class PostRepository {
  Future<void> saveRemote(PostContent post, {File? imageFile});
  Future<PostContent?> loadRemote(String postid);
  Future<void> deleteRemote(String postid);

  Future<void> saveLocal(PostContent post);
  Future<PostContent?> loadLocal(String postid);
  Future<void> deleteLocal(String postid);
  
  Future<List<PostContent>> loadAllLocal();
}
