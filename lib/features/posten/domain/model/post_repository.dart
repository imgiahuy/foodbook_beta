import 'dart:io';
import '../model/post.dart';

abstract class PostRepository {
  Future<void> saveRemote(PostContent post, {File? imageFile});
  Future<PostContent?> loadRemote(String postid);
  Future<void> deleteRemote(String postid);
}
