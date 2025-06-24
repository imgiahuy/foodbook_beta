import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodbook_beta/features/auth/domain/usecases/sign_up_usecase.dart';
import '../domain/entities/user.dart';
import '../domain/usecases/sign_in_usecase.dart';
import '../domain/usecases/sign_out_usecase.dart';

class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final SignInUsecase signInUseCase;
  final SignUpUsecase signUpUseCase;
  final SignOutUsecase signOutUseCase;

  AuthNotifier({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.signOutUseCase,
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

  Future<void> signUp(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await signUpUseCase(email, password);
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
