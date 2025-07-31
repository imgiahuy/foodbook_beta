import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodbook_beta/features/auth/data/repositories/auth_repo_firebase_impl.dart';
import 'package:mocktail/mocktail.dart';

import 'package:foodbook_beta/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:foodbook_beta/features/auth/domain/models/user.dart';
import 'package:foodbook_beta/features/auth/domain/models/auth_repository.dart';
import 'package:foodbook_beta/features/auth/data/dtos/user_model.dart';

class MockFirebaseAuthDatasource extends Mock implements FirebaseAuthDatasource {}

class FakeUserModel extends Fake implements UserModel {}

void main() {
  late MockFirebaseAuthDatasource mockDatasource;
  late AuthRepository repo;

  setUpAll(() {
    registerFallbackValue(FakeUserModel());
  });

  setUp(() {
    mockDatasource = MockFirebaseAuthDatasource();
    repo = AuthRepoFirebaseImpl(mockDatasource);
  });

  group('getCurrentUser', () {
    test('returns User when datasource returns UserModel', () async {
      final userModel = UserModel(
        uid: '123',
        email: 'test@example.com',
        username: 'testuser',
        avatar: 'avatar_url',
      );

      when(() => mockDatasource.currentUser).thenAnswer((_) async => userModel);

      final user = await repo.getCurrentUser();

      expect(user, isA<User>());
      expect(user!.uid, userModel.uid);
      expect(user.username, userModel.username);
      verify(() => mockDatasource.currentUser).called(1);
    });

    test('returns null when datasource returns null', () async {
      when(() => mockDatasource.currentUser).thenAnswer((_) async => null);

      final user = await repo.getCurrentUser();

      expect(user, isNull);
      verify(() => mockDatasource.currentUser).called(1);
    });
  });

  group('signIn', () {
    test('calls datasource.signIn and maps UserModel', () async {
      const email = 'test@example.com';
      const password = 'password123';
      final userModel = UserModel(
        uid: '123',
        email: email,
        username: 'tester',
      );

      when(() => mockDatasource.signIn(email, password))
          .thenAnswer((_) async => userModel);

      final user = await repo.signIn(email, password);

      expect(user, isA<User>());
      expect(user!.uid, userModel.uid);
      verify(() => mockDatasource.signIn(email, password)).called(1);
    });

    test('returns null when datasource returns null', () async {
      const email = 'test@example.com';
      const password = 'password123';

      when(() => mockDatasource.signIn(email, password))
          .thenAnswer((_) async => null);

      final user = await repo.signIn(email, password);

      expect(user, isNull);
      verify(() => mockDatasource.signIn(email, password)).called(1);
    });
  });

  group('signUp', () {
    test('calls datasource.signUp and maps UserModel', () async {
      const email = 'test@example.com';
      const password = 'password123';
      const username = 'newuser';
      final userModel = UserModel(
        uid: '123',
        email: email,
        username: username,
      );

      when(() => mockDatasource.signUp(email, password, username, null))
          .thenAnswer((_) async => userModel);

      final user = await repo.signUp(email, password, username);

      expect(user, isA<User>());
      expect(user!.username, userModel.username);
      verify(() => mockDatasource.signUp(email, password, username, null))
          .called(1);
    });

    test('returns null when datasource returns null', () async {
      const email = 'test@example.com';
      const password = 'password123';
      const username = 'newuser';

      when(() => mockDatasource.signUp(email, password, username, null))
          .thenAnswer((_) async => null);

      final user = await repo.signUp(email, password, username);

      expect(user, isNull);
      verify(() => mockDatasource.signUp(email, password, username, null))
          .called(1);
    });
  });

  group('signOut', () {
    test('calls datasource.signOut', () async {
      when(() => mockDatasource.signOut()).thenAnswer((_) async {});

      await repo.signOut();

      verify(() => mockDatasource.signOut()).called(1);
    });
  });

  group('updateAvatar', () {
    test('calls datasource.updateAvatar', () async {
      final file = File('path/to/avatar.png');
      when(() => mockDatasource.updateAvatar(file)).thenAnswer((_) async {});

      await repo.updateAvatar(file);

      verify(() => mockDatasource.updateAvatar(file)).called(1);
    });
  });

  group('updateUsername', () {
    test('calls datasource.updateUsername', () async {
      const newUsername = 'updatedUser';
      when(() => mockDatasource.updateUsername(newUsername))
          .thenAnswer((_) async {});

      await repo.updateUsername(newUsername);

      verify(() => mockDatasource.updateUsername(newUsername)).called(1);
    });
  });
}
