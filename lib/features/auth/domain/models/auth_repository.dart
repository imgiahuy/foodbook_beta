import 'dart:io';

import 'user.dart';

abstract class AuthRepository {
  Future<User?> signIn(String email, String password);
  Future<User?> signUp(String email, String password, String username, [File? avatarFile]);
  Future<void> signOut();
  Future<User?> getCurrentUser();
  Future<void> updateAvatar(File avatarFile);
  Future<void> updateUsername(String newUsername);

}
