import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodbook_beta/features/posten/domain/model/post.dart';

class PostContentDto {
  final String? username;
  final String? postid;
  final String? image;
  final String? recipe;
  final String? avatarUrl; // <-- add here
  final bool liked;

  PostContentDto({
    this.username,
    this.postid,
    this.image,
    this.recipe,
    this.avatarUrl, // <-- initialize
    this.liked = false,
  });

  /// From Firestore DocumentSnapshot
  factory PostContentDto.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PostContentDto(
      username: data['username'] as String?,
      postid: data['postid'] as String? ?? doc.id,
      image: data['image'] as String?,
      recipe: data['recipe'] as String?,
      avatarUrl: data['avatarUrl'] as String?, // <-- map here
      liked: data['liked'] as bool? ?? false,
    );
  }

  /// To Firestore JSON
  Map<String, dynamic> toFirestore() {
    return {
      'username': username,
      'postid': postid,
      'image': image,
      'recipe': recipe,
      'avatarUrl': avatarUrl, // <-- save to Firestore
      'liked': liked,
    };
  }

  /// Convert DTO -> Domain model
  PostContent toDomain() {
    return PostContent(
      username: username,
      postid: postid,
      image: image,
      recipe: recipe,
      avatarUrl: avatarUrl, // <-- pass to domain
      liked: liked,
    );
  }

  /// Convert Domain model -> DTO
  factory PostContentDto.fromDomain(PostContent post) {
    return PostContentDto(
      username: post.username,
      postid: post.postid,
      image: post.image,
      recipe: post.recipe,
      avatarUrl: post.avatarUrl, // <-- map here
      liked: post.liked,
    );
  }
}
