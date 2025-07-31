import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodbook_beta/features/auth/application/service/get_current_user_usecase.dart';
import 'package:foodbook_beta/features/auth/application/service/sign_up_usecase.dart';
import 'package:foodbook_beta/features/auth/application/service/sign_in_usecase.dart';
import 'package:foodbook_beta/features/auth/application/service/sign_out_usecase.dart';
import 'package:foodbook_beta/features/auth/application/service/update_avatar_usecase.dart';
import '../../domain/models/user.dart';

class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final SignInUsecase signInUseCase;
  final SignUpUsecase signUpUseCase;
  final SignOutUsecase signOutUseCase;
  final GetCurrentUserUsecase getCurrentUserUseCase;
  final UpdateAvatarUseCase updateAvatarUseCase;

  AuthNotifier({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.signOutUseCase,
    required this.getCurrentUserUseCase,
    required this.updateAvatarUseCase,
  }) : super(const AsyncValue.data(null));

  /// Sign In
  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await signInUseCase(email, password);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Sign Up
  Future<void> signUp(
    String email,
    String password,
    String username, [
    File? avatarFile,
  ]) async {
    state = const AsyncValue.loading();
    try {
      final user = await signUpUseCase(email, password, username, avatarFile);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Sign Out
  Future<void> signOut() async {
    await signOutUseCase();
    state = const AsyncValue.data(null);
  }

  /// Update Avatar
  Future<void> updateAvatar(File avatarFile) async {
    state = const AsyncValue.loading();
    try {
      await updateAvatarUseCase(avatarFile);

      // Refresh current user to get updated avatar URL
      final user = await getCurrentUserUseCase();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  Future<void> loadCurrentUser() async {
    state = const AsyncValue.loading();
    try {
      final user = await getCurrentUserUseCase();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
