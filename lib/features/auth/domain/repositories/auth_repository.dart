import '../entities/user.dart';

abstract class AuthRepository {
  Future<User?> signIn(String email, String password);
  Future<User?> signUp(String email, String password);
  Future<void> signOut();
  Future<User?> getCurrentUser();
  //function reset password, update user name, change email added later, forgot password
}
