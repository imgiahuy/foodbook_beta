import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUserUsecase {
  final AuthRepository repository;

  GetCurrentUserUsecase(this.repository);

  Future<User?> call() {
    return repository.getCurrentUser();
  }
}
