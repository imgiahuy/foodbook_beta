import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:foodbook_beta/features/posten/domain/model/post.dart';

part 'post_content_dto.g.dart'; // Hive generator

@HiveType(typeId: 0) // Assign a unique typeId
class PostContentDto {
  @HiveField(0)
  final String? username;

  @HiveField(1)
  final String? postid;

  @HiveField(2)
  final String? image;

  @HiveField(3)
  final String? recipe;

  @HiveField(4)
  final String? avatarUrl;

  @HiveField(5)
  final bool liked;

  PostContentDto({
    this.username,
    this.postid,
    this.image,
    this.recipe,
    this.avatarUrl,
    this.liked = false,
  });

  /// From Firestore
  factory PostContentDto.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PostContentDto(
      username: data['username'] as String?,
      postid: data['postid'] as String? ?? doc.id,
      image: data['image'] as String?,
      recipe: data['recipe'] as String?,
      avatarUrl: data['avatarUrl'] as String?,
      liked: data['liked'] as bool? ?? false,
    );
  }

  /// To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'username': username,
      'postid': postid,
      'image': image,
      'recipe': recipe,
      'avatarUrl': avatarUrl,
      'liked': liked,
    };
  }

  /// DTO -> Domain
  PostContent toDomain() {
    return PostContent(
      username: username,
      postid: postid,
      image: image,
      recipe: recipe,
      avatarUrl: avatarUrl,
      liked: liked,
    );
  }

  /// Domain -> DTO
  factory PostContentDto.fromDomain(PostContent post) {
    return PostContentDto(
      username: post.username,
      postid: post.postid,
      image: post.image,
      recipe: post.recipe,
      avatarUrl: post.avatarUrl,
      liked: post.liked,
    );
  }
}
