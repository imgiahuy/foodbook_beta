import 'dart:io';

import 'package:foodbook_beta/features/auth/domain/models/auth_repository.dart';

class UpdateAvatarUseCase {
  final AuthRepository authRepository;

  UpdateAvatarUseCase(this.authRepository);

  Future<void> call(File avatarFile) async {
    await authRepository.updateAvatar(avatarFile);
  }
}
