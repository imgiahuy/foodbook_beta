import 'package:foodbook_beta/features/auth/domain/models/user.dart';
import 'package:foodbook_beta/features/auth/domain/models/auth_repository.dart';

class SignInUsecase {
  final AuthRepository repository;

  SignInUsecase(this.repository);

  Future<User?> call(String email, String password) {
    return repository.signIn(email, password);
  }
}
