// ignore_for_file: subtype_of_sealed_class

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_test/flutter_test.dart';
import 'package:foodbook_beta/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:foodbook_beta/shared/services/cloudinary_service.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
class MockFirebaseAuth extends Mock implements fb.FirebaseAuth {}

class MockFirebaseUser extends Mock implements fb.User {}

class MockUserCredential extends Mock implements fb.UserCredential {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {}

class MockCloudinaryService extends Mock implements CloudinaryService {}

void main() {
  late MockFirebaseAuth mockAuth;
  late MockFirebaseFirestore mockFirestore;
  late MockCloudinaryService mockCloudinaryService;
  late FirebaseAuthDatasource datasource;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockFirestore = MockFirebaseFirestore();
    mockCloudinaryService = MockCloudinaryService();

    datasource = FirebaseAuthDatasource(
      mockCloudinaryService,
      auth: mockAuth,
      firestore: mockFirestore,
    );
  });

  group('currentUser', () {
    test('returns UserModel when user is logged in', () async {
      final mockUser = MockFirebaseUser();
      final uid = 'user123';
      final mockCollection = MockCollectionReference();
      final mockDocRef = MockDocumentReference();
      final mockDocSnapshot = MockDocumentSnapshot();

      when(() => mockAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.uid).thenReturn(uid);

      when(() => mockFirestore.collection('users')).thenReturn(mockCollection);
      when(() => mockCollection.doc(uid)).thenReturn(mockDocRef);
      when(() => mockDocRef.get()).thenAnswer((_) async => mockDocSnapshot);

      when(() => mockDocSnapshot.data()).thenReturn({
        'username': 'testuser',
        'avatar': 'avatar_url',
      });

      final userModel = await datasource.currentUser;

      expect(userModel, isNotNull);
      expect(userModel!.username, 'testuser');
      expect(userModel.avatar, 'avatar_url');
    });

    test('returns null when no user is logged in', () async {
      when(() => mockAuth.currentUser).thenReturn(null);

      final userModel = await datasource.currentUser;

      expect(userModel, isNull);
    });
  });

  group('signIn', () {
    test('returns UserModel when sign in succeeds', () async {
      final email = 'test@example.com';
      final password = 'password123';
      final uid = 'user123';

      final mockUser = MockFirebaseUser();
      final mockUserCredential = MockUserCredential();

      final mockCollection = MockCollectionReference();
      final mockDocRef = MockDocumentReference();
      final mockDocSnapshot = MockDocumentSnapshot();

      when(() => mockAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          )).thenAnswer((_) async => mockUserCredential);

      when(() => mockUserCredential.user).thenReturn(mockUser);
      when(() => mockUser.uid).thenReturn(uid);

      when(() => mockFirestore.collection('users')).thenReturn(mockCollection);
      when(() => mockCollection.doc(uid)).thenReturn(mockDocRef);
      when(() => mockDocRef.get()).thenAnswer((_) async => mockDocSnapshot);

      when(() => mockDocSnapshot.data()).thenReturn({
        'username': 'testuser',
        'avatar': 'avatar_url',
      });

      final userModel = await datasource.signIn(email, password);

      expect(userModel, isNotNull);
      expect(userModel!.username, 'testuser');
      expect(userModel.avatar, 'avatar_url');
    });

    test('returns null when user is null', () async {
      final email = 'test@example.com';
      final password = 'password123';

      final mockUserCredential = MockUserCredential();

      when(() => mockAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          )).thenAnswer((_) async => mockUserCredential);

      when(() => mockUserCredential.user).thenReturn(null);

      final userModel = await datasource.signIn(email, password);

      expect(userModel, isNull);
    });
  });

  group('signUp', () {
    test('creates user and returns UserModel without avatar', () async {
      final email = 'test@example.com';
      final password = 'password123';
      final username = 'newuser';
      final uid = 'user123';

      final mockUser = MockFirebaseUser();
      final mockUserCredential = MockUserCredential();

      final mockCollection = MockCollectionReference();
      final mockDocRef = MockDocumentReference();

      when(() => mockAuth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          )).thenAnswer((_) async => mockUserCredential);

      when(() => mockUserCredential.user).thenReturn(mockUser);
      when(() => mockUser.uid).thenReturn(uid);

      when(() => mockFirestore.collection('users')).thenReturn(mockCollection);
      when(() => mockCollection.doc(uid)).thenReturn(mockDocRef);

      when(() => mockDocRef.set({
            'username': username,
            'email': email,
          })).thenAnswer((_) async {});

      final userModel = await datasource.signUp(email, password, username, null);

      expect(userModel, isNotNull);
      expect(userModel!.username, username);
      expect(userModel.avatar, isNull);
    });

    test('creates user and uploads avatar if provided', () async {
      final email = 'test@example.com';
      final password = 'password123';
      final username = 'newuser';
      final uid = 'user123';

      final mockUser = MockFirebaseUser();
      final mockUserCredential = MockUserCredential();

      final mockCollection = MockCollectionReference();
      final mockDocRef = MockDocumentReference();

      final avatarFile = File('path/to/avatar.png');
      final avatarUrl = 'http://avatar.url/avatar.png';

      when(() => mockAuth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          )).thenAnswer((_) async => mockUserCredential);

      when(() => mockUserCredential.user).thenReturn(mockUser);
      when(() => mockUser.uid).thenReturn(uid);

      when(() => mockCloudinaryService.uploadImage(avatarFile))
          .thenAnswer((_) async => avatarUrl);

      when(() => mockFirestore.collection('users')).thenReturn(mockCollection);
      when(() => mockCollection.doc(uid)).thenReturn(mockDocRef);

      when(() => mockDocRef.set({
            'username': username,
            'email': email,
            'avatar': avatarUrl,
          })).thenAnswer((_) async {});

      final userModel =
          await datasource.signUp(email, password, username, avatarFile);

      expect(userModel, isNotNull);
      expect(userModel!.username, username);
      expect(userModel.avatar, avatarUrl);
    });

    test('returns null if user creation fails', () async {
      final email = 'test@example.com';
      final password = 'password123';
      final username = 'newuser';

      final mockUserCredential = MockUserCredential();

      when(() => mockAuth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          )).thenAnswer((_) async => mockUserCredential);

      when(() => mockUserCredential.user).thenReturn(null);

      final userModel = await datasource.signUp(email, password, username, null);

      expect(userModel, isNull);
    });
  });

  group('signOut', () {
    test('calls signOut on FirebaseAuth', () async {
      when(() => mockAuth.signOut()).thenAnswer((_) async {});

      await datasource.signOut();

      verify(() => mockAuth.signOut()).called(1);
    });
  });

  group('updateAvatar', () {
    test('uploads new avatar and updates Firestore', () async {
      final uid = 'user123';
      final avatarFile = File('path/to/avatar.png');
      final avatarUrl = 'http://avatar.url/avatar.png';

      final mockUser = MockFirebaseUser();
      final mockCollection = MockCollectionReference();
      final mockDocRef = MockDocumentReference();

      when(() => mockAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.uid).thenReturn(uid);

      when(() => mockCloudinaryService.uploadImage(avatarFile))
          .thenAnswer((_) async => avatarUrl);

      when(() => mockFirestore.collection('users')).thenReturn(mockCollection);
      when(() => mockCollection.doc(uid)).thenReturn(mockDocRef);
      when(() => mockDocRef.update({'avatar': avatarUrl}))
          .thenAnswer((_) async {});

      await datasource.updateAvatar(avatarFile);

      verify(() => mockCloudinaryService.uploadImage(avatarFile)).called(1);
      verify(() => mockDocRef.update({'avatar': avatarUrl})).called(1);
    });

    test('throws Exception if no user is logged in', () async {
      when(() => mockAuth.currentUser).thenReturn(null);

      final avatarFile = File('path/to/avatar.png');

      expect(() => datasource.updateAvatar(avatarFile), throwsException);
    });
  });

  group('updateUsername', () {
    test('updates username in Firestore', () async {
      final uid = 'user123';
      final newUsername = 'updatedUser';

      final mockUser = MockFirebaseUser();
      final mockCollection = MockCollectionReference();
      final mockDocRef = MockDocumentReference();

      when(() => mockAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.uid).thenReturn(uid);

      when(() => mockFirestore.collection('users')).thenReturn(mockCollection);
      when(() => mockCollection.doc(uid)).thenReturn(mockDocRef);
      when(() => mockDocRef.update({'username': newUsername}))
          .thenAnswer((_) async {});

      await datasource.updateUsername(newUsername);

      verify(() => mockDocRef.update({'username': newUsername})).called(1);
    });

    test('throws Exception if no user is logged in', () async {
      when(() => mockAuth.currentUser).thenReturn(null);

      expect(() => datasource.updateUsername('anyName'), throwsException);
    });
  });
}
