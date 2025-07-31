import 'dart:io';
import 'package:foodbook_beta/features/posten/data/datasource/firestore_remote_service.dart';
import 'package:foodbook_beta/features/posten/data/datasource/hive_local.dart';
import 'package:foodbook_beta/features/posten/data/dtos/post_model.dart';
import 'package:foodbook_beta/features/posten/domain/model/post.dart';
import 'package:foodbook_beta/features/posten/domain/model/post_repository.dart';

class PostRepositoryImpl extends PostRepository {
  final FirestoreDataSource _dataSource;
  final HiveLocalDataSource _localDataSource;

  PostRepositoryImpl({
    FirestoreDataSource? dataSource,
    HiveLocalDataSource? localDataSource,
  }) : _dataSource = dataSource ?? FirestoreDataSource(),
       _localDataSource = localDataSource ?? HiveLocalDataSource();
  @override
  Future<void> saveRemote(PostContent post, {File? imageFile}) async {
    final dto = PostContentDto.fromDomain(post);
    await _dataSource.createOrUpdate(dto, imageFile: imageFile);
  }

  @override
  Future<PostContent?> loadRemote(String postid) async {
    final dto = await _dataSource.read(postid);
    return dto?.toDomain();
  }

  @override
  Future<void> deleteRemote(String postid) async {
    await _dataSource.delete(postid);
  }

  Future<List<PostContent>> loadAllRemote() async {
    final allDtos = await _dataSource.readAll();
    return allDtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<void> saveLocal(PostContent post) async {
    await _localDataSource.save(post);
  }

  @override
  Future<PostContent?> loadLocal(String postid) async {
    return await _localDataSource.load(postid);
  }

  @override
  Future<void> deleteLocal(String postid) async {
    await _localDataSource.delete(postid);
  }

  @override
  Future<List<PostContent>> loadAllLocal() async {
    return await _localDataSource.loadAll();
  }
}
