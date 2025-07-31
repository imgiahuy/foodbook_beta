import 'dart:io';

import 'package:foodbook_beta/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:foodbook_beta/features/auth/domain/models/user.dart';
import 'package:foodbook_beta/features/auth/domain/models/auth_repository.dart';

class AuthRepoFirebaseImpl extends AuthRepository {
  final FirebaseAuthDatasource datasource;

  AuthRepoFirebaseImpl(this.datasource);

  @override
  Future<User?> getCurrentUser() async {
    final userModel = await datasource.currentUser; // now async
    return userModel?.toEntity();
  }

  @override
  Future<User?> signIn(String email, String password) async {
    final userModel = await datasource.signIn(email, password);
    return userModel?.toEntity();
  }

  @override
  Future<void> signOut() async {
    await datasource.signOut();
  }

  @override
  Future<User?> signUp(
    String email,
    String password,
    String username, [
    File? avatarFile,
  ]) async {
    final userModel = await datasource.signUp(
      email,
      password,
      username,
      avatarFile,
    );
    return userModel?.toEntity();
  }

  @override
  Future<void> updateAvatar(File avatarFile) async {
    await datasource.updateAvatar(avatarFile);
  }

  @override
  Future<void> updateUsername(String newUsername) async {
    await datasource.updateUsername(newUsername);
  }
}
