// ignore_for_file: subtype_of_sealed_class

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodbook_beta/features/posten/data/datasource/firestore_remote_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:foodbook_beta/features/posten/data/dtos/post_model.dart';
import 'package:foodbook_beta/shared/services/cloudinary_service.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock implements CollectionReference {}

class MockDocumentReference extends Mock implements DocumentReference {}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

class MockCloudinaryService extends Mock implements CloudinaryService {}

void main() {
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference mockCollection;
  late MockDocumentReference mockDocRef;
  late MockCloudinaryService mockCloudinary;
  late FirestoreDataSource dataSource;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference();
    mockDocRef = MockDocumentReference();
    mockCloudinary = MockCloudinaryService();

    when(() => mockFirestore.collection(any())).thenReturn(mockCollection as CollectionReference<Map<String, dynamic>>);
    when(() => mockCollection.doc(any())).thenReturn(mockDocRef);

    dataSource = FirestoreDataSource(
      firestore: mockFirestore,
      cloudinary: mockCloudinary,
    );
  });

  group('createOrUpdate', () {
    test('uploads image if imageFile provided and sets Firestore doc', () async {
      final dto = PostContentDto(
        username: 'user1',
        postid: 'post123',
        image: 'oldUrl',
        recipe: 'recipe details',
        liked: false,
        avatarUrl: 'avatarUrl',
      );

      final fakeFile = File('path/to/image.jpg');
      final uploadedUrl = 'https://cloudinary.com/image123.jpg';

      when(() => mockCloudinary.uploadImage(fakeFile))
          .thenAnswer((_) async => uploadedUrl);

      when(() => mockDocRef.set(any())).thenAnswer((_) async {});

      await dataSource.createOrUpdate(dto, imageFile: fakeFile);

      verify(() => mockCloudinary.uploadImage(fakeFile)).called(1);

      final captured = verify(() => mockDocRef.set(captureAny())).captured.single as Map<String, dynamic>;
      expect(captured['image'], uploadedUrl);
      expect(captured['username'], dto.username);
    });
  });

  group('read', () {
    test('returns PostContentDto when document exists', () async {
      final docId = 'post123';

      final mockSnapshot = MockDocumentSnapshot();

      when(() => mockDocRef.get()).thenAnswer((_) async => mockSnapshot);
      when(() => mockFirestore.collection(any())).thenReturn(mockCollection as CollectionReference<Map<String, dynamic>>);
      when(() => mockCollection.doc(docId)).thenReturn(mockDocRef);

      when(() => mockSnapshot.exists).thenReturn(true);
      when(() => mockSnapshot.data()).thenReturn({
        'username': 'user1',
        'postid': docId,
        'image': 'image_url',
        'recipe': 'recipe',
        'liked': false,
        'avatarUrl': 'avatarUrl',
      });

      final result = await dataSource.read(docId);

      expect(result, isNotNull);
      expect(result!.postid, docId);
      expect(result.username, 'user1');
    });
  });
}
