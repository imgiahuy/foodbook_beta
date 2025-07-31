import 'dart:io';
import 'package:foodbook_beta/features/posten/data/datasource/firestore_remote_service.dart';
import 'package:foodbook_beta/features/posten/data/dtos/post_model.dart';
import 'package:foodbook_beta/features/posten/domain/model/post.dart';
import 'package:foodbook_beta/features/posten/domain/model/post_repository.dart';

class PostRepositoryImpl extends PostRepository {
  final FirestoreDataSource _dataSource;

  PostRepositoryImpl({FirestoreDataSource? dataSource})
      : _dataSource = dataSource ?? FirestoreDataSource();

  @override
  Future<void> saveRemote(PostContent post, {File? imageFile}) async {
    // Convert domain model to DTO
    final dto = PostContentDto.fromDomain(post);

    // Use FirestoreDataSource to create or update the post, including image upload if provided
    await _dataSource.createOrUpdate(dto, imageFile: imageFile);
  }

  @override
  Future<PostContent?> loadRemote(String postid) async {
    final dto = await _dataSource.read(postid);
    if (dto == null) return null;

    // Convert DTO back to domain model
    return dto.toDomain();
  }

  @override
  Future<void> deleteRemote(String postid) async {
    await _dataSource.delete(postid);
  }

  Future<List<PostContent>> loadAllRemote() async {
    final allDtos = await _dataSource.readAll();
    return allDtos.map((dto) => dto.toDomain()).toList();
  }
}
