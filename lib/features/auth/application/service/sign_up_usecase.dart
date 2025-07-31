import 'dart:io';

import 'package:foodbook_beta/features/auth/domain/models/auth_repository.dart';
import 'package:foodbook_beta/features/auth/domain/models/user.dart';

class SignUpUsecase {
  final AuthRepository repository;

  SignUpUsecase(this.repository);

  Future<User?> call(
    String email,
    String password,
    String username,
    [File? avatarFile]  // Add this optional param
  ) {
    return repository.signUp(email, password, username, avatarFile);
  }
}
