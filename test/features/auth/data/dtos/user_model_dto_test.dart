import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

import 'package:foodbook_beta/features/auth/data/dtos/user_model.dart';
import 'package:foodbook_beta/features/auth/domain/models/user.dart';

class FakeFirebaseUser implements fb.User {
  @override
  final String uid;
  @override
  final String? email;

  FakeFirebaseUser({required this.uid, this.email});

  // Alle anderen Properties/Methode können `noSuchMethod` verwenden
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('UserModel', () {
    test('fromFirebaseUser erstellt korrektes UserModel', () {
      final fbUser = FakeFirebaseUser(uid: '123', email: 'test@example.com');
      final userModel = UserModel.fromFirebaseUser(fbUser,
          username: 'tester', avatar: 'avatar_url');

      expect(userModel.uid, '123');
      expect(userModel.email, 'test@example.com');
      expect(userModel.username, 'tester');
      expect(userModel.avatar, 'avatar_url');
    });

    test('fromJson erstellt korrektes UserModel', () {
      final json = {
        'uid': '123',
        'email': 'test@example.com',
        'username': 'tester',
        'avatar': 'avatar_url',
      };

      final userModel = UserModel.fromJson(json);

      expect(userModel.uid, json['uid']);
      expect(userModel.email, json['email']);
      expect(userModel.username, json['username']);
      expect(userModel.avatar, json['avatar']);
    });

    test('toJson gibt korrektes Map zurück', () {
      final userModel = UserModel(
        uid: '123',
        email: 'test@example.com',
        username: 'tester',
        avatar: 'avatar_url',
      );

      final json = userModel.toJson();

      expect(json, {
        'uid': '123',
        'email': 'test@example.com',
        'username': 'tester',
        'avatar': 'avatar_url',
      });
    });

    test('toEntity mappt korrekt auf Domain-User', () {
      final userModel = UserModel(
        uid: '123',
        email: 'test@example.com',
        username: 'tester',
        avatar: 'avatar_url',
      );

      final user = userModel.toEntity();

      expect(user, isA<User>());
      expect(user.uid, '123');
      expect(user.username, 'tester');
    });
  });
}
