import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodbook_beta/features/auth/application/service/get_current_user_usecase.dart';
import 'package:foodbook_beta/features/auth/application/service/sign_in_usecase.dart';
import 'package:foodbook_beta/features/auth/application/service/sign_out_usecase.dart';
import 'package:foodbook_beta/features/auth/application/service/sign_up_usecase.dart';
import 'package:foodbook_beta/features/auth/application/service/update_avatar_usecase.dart';
import 'package:foodbook_beta/features/auth/application/service/update_username.dart';
import 'package:foodbook_beta/features/auth/domain/models/user.dart';
import 'package:foodbook_beta/features/auth/presentation/states/auth_notifier.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes for use cases
class MockSignInUsecase extends Mock implements SignInUsecase {}

class MockSignUpUsecase extends Mock implements SignUpUsecase {}

class MockSignOutUsecase extends Mock implements SignOutUsecase {}

class MockGetCurrentUserUsecase extends Mock implements GetCurrentUserUsecase {}

class MockUpdateAvatarUseCase extends Mock implements UpdateAvatarUseCase {}

class MockUpdateUserNameUseCase extends Mock implements UpdateUserNameUseCase {}

void main() {
  late AuthNotifier authNotifier;
  late MockSignInUsecase mockSignInUsecase;
  late MockSignUpUsecase mockSignUpUsecase;
  late MockSignOutUsecase mockSignOutUsecase;
  late MockGetCurrentUserUsecase mockGetCurrentUserUsecase;
  late MockUpdateAvatarUseCase mockUpdateAvatarUseCase;
  late MockUpdateUserNameUseCase mockUpdateUserNameUseCase;

  // Dummy user object to simulate a user returned from usecases
  final testUser = User(
    uid: '123',
    username: 'testuser',
    email: 'test@example.com',
    avatar: 'http://avatar.url/image.png',
  );

  setUp(() {
    mockSignInUsecase = MockSignInUsecase();
    mockSignUpUsecase = MockSignUpUsecase();
    mockSignOutUsecase = MockSignOutUsecase();
    mockGetCurrentUserUsecase = MockGetCurrentUserUsecase();
    mockUpdateAvatarUseCase = MockUpdateAvatarUseCase();
    mockUpdateUserNameUseCase = MockUpdateUserNameUseCase();

    authNotifier = AuthNotifier(
      signInUseCase: mockSignInUsecase,
      signUpUseCase: mockSignUpUsecase,
      signOutUseCase: mockSignOutUsecase,
      getCurrentUserUseCase: mockGetCurrentUserUsecase,
      updateAvatarUseCase: mockUpdateAvatarUseCase,
      updateUserNameUseCase: mockUpdateUserNameUseCase,
    );
  });

  group('signIn', () {
    test('emits loading and then data on success', () async {
      when(() => mockSignInUsecase('email', 'password'))
          .thenAnswer((_) async => testUser);

      final states = <AsyncValue<User?>>[];
      authNotifier.addListener((state) => states.add(state));

      await authNotifier.signIn('email', 'password');

      expect(states.length, 2);
      expect(states[0].isLoading, true);
      expect(states[1].value, testUser);
      verify(() => mockSignInUsecase('email', 'password')).called(1);
    });

    test('emits loading and then error on failure', () async {
      final exception = Exception('SignIn Failed');
      when(() => mockSignInUsecase('email', 'password'))
          .thenThrow(exception);

      final states = <AsyncValue<User?>>[];
      authNotifier.addListener((state) => states.add(state));

      await authNotifier.signIn('email', 'password');

      expect(states.length, 2);
      expect(states[0].isLoading, true);
      expect(states[1].hasError, true);
      verify(() => mockSignInUsecase('email', 'password')).called(1);
    });
  });

  group('signUp', () {
    test('emits loading and then data on success', () async {
      when(() => mockSignUpUsecase('email', 'password', 'username', null))
          .thenAnswer((_) async => testUser);

      final states = <AsyncValue<User?>>[];
      authNotifier.addListener((state) => states.add(state));

      await authNotifier.signUp('email', 'password', 'username');

      expect(states.length, 2);
      expect(states[0].isLoading, true);
      expect(states[1].value, testUser);
      verify(() => mockSignUpUsecase('email', 'password', 'username', null))
          .called(1);
    });

    test('emits loading and then error on failure', () async {
      final exception = Exception('SignUp Failed');
      when(() => mockSignUpUsecase('email', 'password', 'username', null))
          .thenThrow(exception);

      final states = <AsyncValue<User?>>[];
      authNotifier.addListener((state) => states.add(state));

      await authNotifier.signUp('email', 'password', 'username');

      expect(states.length, 2);
      expect(states[0].isLoading, true);
      expect(states[1].hasError, true);
      verify(() => mockSignUpUsecase('email', 'password', 'username', null))
          .called(1);
    });
  });

  group('signOut', () {
    test('calls signOutUseCase and emits null user', () async {
      when(() => mockSignOutUsecase()).thenAnswer((_) async {});

      final states = <AsyncValue<User?>>[];
      authNotifier.addListener((state) => states.add(state));

      await authNotifier.signOut();

      expect(states.length, 1);
      expect(states[0].value, null);
      verify(() => mockSignOutUsecase()).called(1);
    });
  });

  group('updateAvatar', () {
    final dummyFile = File('path/to/file.png');

    test('emits loading and then data on success', () async {
      when(() => mockUpdateAvatarUseCase(dummyFile))
          .thenAnswer((_) async {});

      when(() => mockGetCurrentUserUsecase())
          .thenAnswer((_) async => testUser);

      final states = <AsyncValue<User?>>[];
      authNotifier.addListener((state) => states.add(state));

      await authNotifier.updateAvatar(dummyFile);

      expect(states.length, 2);
      expect(states[0].isLoading, true);
      expect(states[1].value, testUser);
      verify(() => mockUpdateAvatarUseCase(dummyFile)).called(1);
      verify(() => mockGetCurrentUserUsecase()).called(1);
    });

    test('emits loading and then error on failure', () async {
      final exception = Exception('Update Avatar Failed');

      when(() => mockUpdateAvatarUseCase(dummyFile))
          .thenThrow(exception);

      final states = <AsyncValue<User?>>[];
      authNotifier.addListener((state) => states.add(state));

      await authNotifier.updateAvatar(dummyFile);

      expect(states.length, 2);
      expect(states[0].isLoading, true);
      expect(states[1].hasError, true);
      verify(() => mockUpdateAvatarUseCase(dummyFile)).called(1);
    });
  });

  group('updateUsername', () {
    test('emits loading and then data on success', () async {
      when(() => mockUpdateUserNameUseCase('newusername'))
          .thenAnswer((_) async {});

      when(() => mockGetCurrentUserUsecase())
          .thenAnswer((_) async => testUser);

      final states = <AsyncValue<User?>>[];
      authNotifier.addListener((state) => states.add(state));

      await authNotifier.updateUsername('newusername');

      expect(states.length, 2);
      expect(states[0].isLoading, true);
      expect(states[1].value, testUser);
      verify(() => mockUpdateUserNameUseCase('newusername')).called(1);
      verify(() => mockGetCurrentUserUsecase()).called(1);
    });

    test('emits loading and then error on failure', () async {
      final exception = Exception('Update Username Failed');

      when(() => mockUpdateUserNameUseCase('newusername'))
          .thenThrow(exception);

      final states = <AsyncValue<User?>>[];
      authNotifier.addListener((state) => states.add(state));

      await authNotifier.updateUsername('newusername');

      expect(states.length, 2);
      expect(states[0].isLoading, true);
      expect(states[1].hasError, true);
      verify(() => mockUpdateUserNameUseCase('newusername')).called(1);
    });
  });

  group('loadCurrentUser', () {
    test('emits loading and then data on success', () async {
      when(() => mockGetCurrentUserUsecase())
          .thenAnswer((_) async => testUser);

      final states = <AsyncValue<User?>>[];
      authNotifier.addListener((state) => states.add(state));

      await authNotifier.loadCurrentUser();

      expect(states.length, 2);
      expect(states[0].isLoading, true);
      expect(states[1].value, testUser);
      verify(() => mockGetCurrentUserUsecase()).called(1);
    });

    test('emits loading and then error on failure', () async {
      final exception = Exception('Load User Failed');

      when(() => mockGetCurrentUserUsecase())
          .thenThrow(exception);

      final states = <AsyncValue<User?>>[];
      authNotifier.addListener((state) => states.add(state));

      await authNotifier.loadCurrentUser();

      expect(states.length, 2);
      expect(states[0].isLoading, true);
      expect(states[1].hasError, true);
      verify(() => mockGetCurrentUserUsecase()).called(1);
    });
  });
}
