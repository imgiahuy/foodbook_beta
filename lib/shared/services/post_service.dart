import 'package:foodbook_beta/features/posten/domain/model/post.dart';

abstract class PostService {
  PostContent getPost(postid);
}
