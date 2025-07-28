import 'package:foodbook_beta/features/auth/domain/models/user.dart';
import 'package:foodbook_beta/features/auth/domain/models/auth_repository.dart';

class SignUpUsecase {
  final AuthRepository repository;

  SignUpUsecase(this.repository);

  Future<User?> call(String email, String password, String username) {
    return repository.signUp(email, password, username);
  }
}
