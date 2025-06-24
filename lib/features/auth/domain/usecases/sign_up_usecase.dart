import 'package:foodbook_beta/features/auth/domain/entities/user.dart';
import 'package:foodbook_beta/features/auth/domain/repositories/auth_repository.dart';

class SignUpUsecase {
  final AuthRepository repository;

  SignUpUsecase(this.repository);

  Future<User?> call(String email, String password) {
    return repository.signUp(email, password);
  }
}
