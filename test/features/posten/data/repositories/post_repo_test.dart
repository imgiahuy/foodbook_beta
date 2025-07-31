import 'dart:io';

import 'package:foodbook_beta/features/posten/data/repositories/post_impl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:foodbook_beta/features/posten/data/datasource/firestore_remote_service.dart';
import 'package:foodbook_beta/features/posten/data/datasource/hive_local.dart';
import 'package:foodbook_beta/features/posten/data/dtos/post_model.dart';
import 'package:foodbook_beta/features/posten/domain/model/post.dart';

// Mock classes
class MockFirestoreDataSource extends Mock implements FirestoreDataSource {}
class MockHiveLocalDataSource extends Mock implements HiveLocalDataSource {}

void main() {
  late MockFirestoreDataSource mockRemote;
  late MockHiveLocalDataSource mockLocal;
  late PostRepositoryImpl repository;

  setUp(() {
    mockRemote = MockFirestoreDataSource();
    mockLocal = MockHiveLocalDataSource();
    repository = PostRepositoryImpl(dataSource: mockRemote, localDataSource: mockLocal);
  });

  final testPost = PostContent(
    postid: 'test_id',
    username: 'test_user',
    image: 'test_image',
    recipe: 'test_recipe',
    liked: false,
    avatarUrl: 'avatar_url',
  );

  final testDto = PostContentDto.fromDomain(testPost);
  test('saveRemote calls FirestoreDataSource.createOrUpdate with dto and imageFile', () async {
    when(() => mockRemote.createOrUpdate(any(), imageFile: any(named: 'imageFile')))
        .thenAnswer((_) async {});

    final imageFile = File('path/to/image.png');

    await repository.saveRemote(testPost, imageFile: imageFile);

    verify(() => mockRemote.createOrUpdate(testDto, imageFile: imageFile)).called(1);
  });

    test('loadRemote returns domain PostContent when FirestoreDataSource.read returns dto', () async {
    when(() => mockRemote.read(testPost.postid!)).thenAnswer((_) async => testDto);

    final result = await repository.loadRemote(testPost.postid!);

    expect(result, equals(testPost));
    verify(() => mockRemote.read(testPost.postid!)).called(1);
  });

    test('saveLocal calls HiveLocalDataSource.save with post', () async {
    when(() => mockLocal.save(testPost)).thenAnswer((_) async {});

    await repository.saveLocal(testPost);

    verify(() => mockLocal.save(testPost)).called(1);
  });

    test('loadLocal returns PostContent from HiveLocalDataSource.load', () async {
    when(() => mockLocal.load(testPost.postid!)).thenAnswer((_) async => testPost);

    final result = await repository.loadLocal(testPost.postid!);

    expect(result, equals(testPost));
    verify(() => mockLocal.load(testPost.postid!)).called(1);
  });



}