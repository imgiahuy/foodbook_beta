import 'package:hive/hive.dart';
import 'package:foodbook_beta/features/posten/domain/model/post.dart';

class HiveLocalDataSource {
  static const String _boxName = 'posts_box';

  Future<Box<PostContent>> _openBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<PostContent>(_boxName);
    }
    return Hive.box<PostContent>(_boxName);
  }

  Future<void> save(PostContent post) async {
    final box = await _openBox();
    await box.put(post.postid, post);
  }

  Future<PostContent?> load(String postid) async {
    final box = await _openBox();
    return box.get(postid);
  }

  Future<void> delete(String postid) async {
    final box = await _openBox();
    await box.delete(postid);
  }

  Future<List<PostContent>> loadAll() async {
    final box = await _openBox();
    return box.values.toList();
  }
}
