import 'package:foodbook_beta/features/posten/domain/model/post.dart';
import 'package:hive/hive.dart';

class HiveLocalDataSource {
  static const String _boxName = 'posts_box';

  final Future<Box<PostContent>> Function() openBoxFunction;

  HiveLocalDataSource({Future<Box<PostContent>> Function()? openBoxFunc})
      : openBoxFunction = openBoxFunc ?? _defaultOpenBox;

  static Future<Box<PostContent>> _defaultOpenBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<PostContent>(_boxName);
    }
    return Hive.box<PostContent>(_boxName);
  }

  Future<void> save(PostContent post) async {
    final box = await openBoxFunction();
    await box.put(post.postid, post);
  }

  Future<PostContent?> load(String postid) async {
    final box = await openBoxFunction();
    return box.get(postid);
  }

  Future<void> delete(String postid) async {
    final box = await openBoxFunction();
    await box.delete(postid);
  }

  Future<List<PostContent>> loadAll() async {
    final box = await openBoxFunction();
    return box.values.toList();
  }
}
