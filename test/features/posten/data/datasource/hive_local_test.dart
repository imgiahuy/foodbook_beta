import 'package:flutter_test/flutter_test.dart';
import 'package:foodbook_beta/features/posten/data/datasource/hive_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hive/hive.dart';
import 'package:foodbook_beta/features/posten/domain/model/post.dart';

class MockBox<T> extends Mock implements Box<T> {}

void main() {
  late HiveLocalDataSource dataSource;
  late MockBox<PostContent> mockBox;

  setUp(() {
    mockBox = MockBox<PostContent>();

    dataSource = HiveLocalDataSource(openBoxFunc: () async => mockBox);
  });

  group('save', () {
    test('calls box.put with the post', () async {
      final post = PostContent(
        postid: 'post123',
        username: 'user1',
        image: 'image_url',
        recipe: 'recipe',
        liked: false,
        avatarUrl: 'avatarUrl',
      );

      when(() => mockBox.put(post.postid, post)).thenAnswer((_) async {});

      await dataSource.save(post);

      verify(() => mockBox.put(post.postid, post)).called(1);
    });
  });

  group('load', () {
    test('calls box.get with the postid and returns the PostContent', () async {
      final post = PostContent(
        postid: 'post123',
        username: 'user1',
        image: 'image_url',
        recipe: 'recipe',
        liked: false,
        avatarUrl: 'avatarUrl',
      );

      when(() => mockBox.get('post123')).thenReturn(post);

      final result = await dataSource.load('post123');

      verify(() => mockBox.get('post123')).called(1);
      expect(result, equals(post));
    });
  });
}
