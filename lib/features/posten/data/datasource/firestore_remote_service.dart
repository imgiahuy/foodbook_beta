import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodbook_beta/features/posten/data/dtos/post_model.dart';
import '../../../../shared/services/cloudinary_service.dart';

class FirestoreDataSource {
  final FirebaseFirestore _firestore;
  final CloudinaryService _cloudinary;
  final String collectionName;

  FirestoreDataSource({
    FirebaseFirestore? firestore,
    CloudinaryService? cloudinary,
    this.collectionName = 'posts',
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _cloudinary = cloudinary ?? CloudinaryService();

  Future<void> createOrUpdate(PostContentDto dto, {File? imageFile}) async {
    String? imageUrl = dto.image;

    if (imageFile != null) {
      imageUrl = await _cloudinary.uploadImage(imageFile);
    }

    final updatedDto = PostContentDto(
      username: dto.username,
      postid: dto.postid,
      image: imageUrl,
      recipe: dto.recipe,
      liked: dto.liked,
      avatarUrl: dto.avatarUrl,
    );

    await _firestore
        .collection(collectionName)
        .doc(updatedDto.postid)
        .set(updatedDto.toFirestore());
  }

  Future<PostContentDto?> read(String docId) async {
    final snapshot = await _firestore
        .collection(collectionName)
        .doc(docId)
        .get();
    if (snapshot.exists) {
      return PostContentDto.fromFirestore(snapshot);
    }
    return null;
  }

  Future<void> delete(String docId) async {
    await _firestore.collection(collectionName).doc(docId).delete();
  }

  Future<List<PostContentDto>> readAll() async {
    final snapshot = await _firestore.collection(collectionName).get();
    return snapshot.docs
        .map((doc) => PostContentDto.fromFirestore(doc))
        .toList();
  }

  Future<void> updateLikeStatus({
    required String postId,
    required bool liked,
    required int likeCount,
  }) async {
    final doc = FirebaseFirestore.instance.collection('posts').doc(postId);

    await doc.update({'liked': liked, 'likeCount': likeCount});
  }
}
