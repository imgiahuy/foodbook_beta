import 'package:foodbook_beta/features/auth/domain/repositories/auth_repository.dart';

class SignOutUsecase {
  final AuthRepository repository;

  SignOutUsecase(this.repository);

  Future<void> call() {
    return repository.signOut();
  }
}
