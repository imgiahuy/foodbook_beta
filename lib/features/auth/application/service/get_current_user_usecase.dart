import '../../domain/models/user.dart';
import '../../domain/models/auth_repository.dart';

class GetCurrentUserUsecase {
  final AuthRepository repository;

  GetCurrentUserUsecase(this.repository);

  Future<User?> call() {
    return repository.getCurrentUser();
  }
}
