import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodbook_beta/features/auth/application/service/update_username.dart';
import 'package:foodbook_beta/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:foodbook_beta/features/auth/data/repositories/auth_repo_firebase_impl.dart';
import 'package:foodbook_beta/features/auth/domain/models/user.dart';
import 'package:foodbook_beta/features/auth/domain/models/auth_repository.dart';
import 'package:foodbook_beta/features/auth/application/service/get_current_user_usecase.dart';
import 'package:foodbook_beta/features/auth/application/service/sign_in_usecase.dart';
import 'package:foodbook_beta/shared/services/cloudinary_service.dart';
import 'auth_notifier.dart';
import 'package:foodbook_beta/features/auth/application/service/sign_out_usecase.dart';
import 'package:foodbook_beta/features/auth/application/service/sign_up_usecase.dart';
import 'package:foodbook_beta/features/auth/application/service/update_avatar_usecase.dart';

final cloudinaryServiceProvider = Provider<CloudinaryService>((ref) {
  return CloudinaryService();
});

// Provide the Firebase auth datasource, injecting CloudinaryService
final authDatasourceProvider = Provider<FirebaseAuthDatasource>((ref) {
  final cloudinaryService = ref.read(cloudinaryServiceProvider);
  return FirebaseAuthDatasource(cloudinaryService);
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

final updateAvatarUseCaseProvider = Provider<UpdateAvatarUseCase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return UpdateAvatarUseCase(authRepository);
});

final updateUserNameUseCaseProvider = Provider<UpdateUserNameUseCase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return UpdateUserNameUseCase(authRepository);
});

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
      return AuthNotifier(
        signInUseCase: ref.read(signInUseCaseProvider),
        signUpUseCase: ref.read(signUpUseCaseProvider),
        signOutUseCase: ref.read(signOutUseCaseProvider),
        getCurrentUserUseCase: ref.read(getCurrentUserUseCaseProvider),
        updateAvatarUseCase: ref.read(updateAvatarUseCaseProvider),
        updateUserNameUseCase: ref.read(updateUserNameUseCaseProvider)
      );
    });

final termsAcceptedProvider = StateProvider<bool>((ref) => false);
