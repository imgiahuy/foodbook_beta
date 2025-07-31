import 'dart:io';
import '../model/post.dart';

abstract class PostRepository {
  Future<void> saveRemote(PostContent post, {File? imageFile});
  Future<PostContent?> loadRemote(String postid);
  Future<void> deleteRemote(String postid);
   // Local methods
  Future<void> saveLocal(PostContent post);
  Future<PostContent?> loadLocal(String postid);
  Future<void> deleteLocal(String postid);
}
