import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodbook_beta/features/auth/application/service/get_current_user_usecase.dart';
import 'package:foodbook_beta/features/auth/application/service/sign_up_usecase.dart';
import '../../domain/models/user.dart';
import '../../application/service/sign_in_usecase.dart';
import '../../application/service/sign_out_usecase.dart';

class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final SignInUsecase signInUseCase;
  final SignUpUsecase signUpUseCase;
  final SignOutUsecase signOutUseCase;
  final GetCurrentUserUsecase getCurrentUserUseCase;

  AuthNotifier({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.signOutUseCase,
    required this.getCurrentUserUseCase,
  }) : super(const AsyncValue.data(null));

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await signInUseCase(email, password);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signUp(String email, String password, String username) async {
    state = const AsyncValue.loading();
    try {
      final user = await signUpUseCase(email, password, username);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signOut() async {
    await signOutUseCase();
    state = const AsyncValue.data(null);
  }
}
