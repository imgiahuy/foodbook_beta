import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodbook_beta/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:foodbook_beta/features/auth/data/repositories/auth_repo_firebase_impl.dart';
import 'package:foodbook_beta/features/auth/domain/models/user.dart';
import 'package:foodbook_beta/features/auth/domain/models/auth_repository.dart';
import 'package:foodbook_beta/features/auth/application/service/get_current_user_usecase.dart';
import 'package:foodbook_beta/features/auth/application/service/sign_in_usecase.dart';
import 'auth_notifier.dart';
import 'package:foodbook_beta/features/auth/application/service/sign_out_usecase.dart';
import 'package:foodbook_beta/features/auth/application/service/sign_up_usecase.dart';

final authDatasourceProvider = Provider<FirebaseAuthDatasource>((ref) {
  return FirebaseAuthDatasource();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final datasource = ref.read(authDatasourceProvider);
  return AuthRepoFirebaseImpl(datasource);
});

final signInUseCaseProvider = Provider<SignInUsecase>((ref) {
  return SignInUsecase(ref.read(authRepositoryProvider));
});

final signUpUseCaseProvider = Provider<SignUpUsecase>((ref) {
  return SignUpUsecase(ref.read(authRepositoryProvider));
});

final signOutUseCaseProvider = Provider<SignOutUsecase>((ref) {
  return SignOutUsecase(ref.read(authRepositoryProvider));
});

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUsecase>((ref) {
  return GetCurrentUserUsecase(ref.read(authRepositoryProvider));
});

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
      return AuthNotifier(
        signInUseCase: ref.read(signInUseCaseProvider),
        signUpUseCase: ref.read(signUpUseCaseProvider),
        signOutUseCase: ref.read(signOutUseCaseProvider),
        getCurrentUserUseCase: ref.read(getCurrentUserUseCaseProvider),
      );
    });

final termsAcceptedProvider = StateProvider<bool>((ref) => false);
