import 'package:foodbook_beta/features/posten/domain/model/post.dart';

abstract class PostRepository {
  void saveLocal(PostContent post);
  PostContent loadLocal(int postid);
  void saveRemote(PostContent post);
  PostContent loadRemote(int postid);
  void deleteLocal(int postid);
  void deleteRemote(int postid);
}
