import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodbook_beta/features/auth/domain/models/user.dart';
import 'package:foodbook_beta/features/auth/presentation/controller/register_controller.dart';
import 'package:foodbook_beta/features/auth/presentation/states/auth_notifier.dart';
import 'package:foodbook_beta/features/auth/presentation/states/auth_provider.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
class MockWidgetRef extends Mock implements WidgetRef {}
class MockAuthNotifier extends Mock implements AuthNotifier {}

void main() {
  late MockWidgetRef mockRef;
  late MockAuthNotifier mockAuthNotifier;
  late RegisterController controller;

  setUp(() {
    mockRef = MockWidgetRef();
    mockAuthNotifier = MockAuthNotifier();

    when(() => mockRef.read(authNotifierProvider.notifier))
        .thenReturn(mockAuthNotifier);

    controller = RegisterController(mockRef);
  });

  test('signUp calls authNotifier.signUp when isChecked true and not loading', () {
    final email = 'test@example.com';
    final password = 'password123';
    final username = 'testuser';
    final isChecked = true;
    final authState = AsyncValue<User?>.data(null); // Explicit typing here
    final avatarFile = null;

    controller.signUp(email, password, username, isChecked, authState, avatarFile);

    verify(() => mockAuthNotifier.signUp(email, password, username, avatarFile))
        .called(1);
  });

  test('signUp does not call authNotifier.signUp when isChecked false', () {
    final email = 'test@example.com';
    final password = 'password123';
    final username = 'testuser';
    final isChecked = false;
    final authState = AsyncValue<User?>.data(null); // Explicit typing here
    final avatarFile = null;

    controller.signUp(email, password, username, isChecked, authState, avatarFile);

    verifyNever(() => mockAuthNotifier.signUp(any(), any(), any(), any()));
  });

  test('signUp does not call authNotifier.signUp when authState is loading', () {
    final email = 'test@example.com';
    final password = 'password123';
    final username = 'testuser';
    final isChecked = true;
    final authState = AsyncValue<User?>.loading(); // Explicit typing here
    final avatarFile = null;

    controller.signUp(email, password, username, isChecked, authState, avatarFile);

    verifyNever(() => mockAuthNotifier.signUp(any(), any(), any(), any()));
  });
}
