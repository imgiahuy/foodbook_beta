import 'package:foodbook_beta/features/auth/domain/models/auth_repository.dart';

class UpdateUserNameUseCase {
  final AuthRepository authRepository;

  UpdateUserNameUseCase(this.authRepository);

  Future<void> call(String newUsername) async {
    await authRepository.updateUsername(newUsername);
  }
}
