import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../model/user_model.dart';

class FirebaseAuthDatasource {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;

  UserModel? get currentUser {
    final fbUser = _auth.currentUser;
    if (fbUser != null) {
      return UserModel.fromFirebaseUser(fbUser);
    }
    return null;
  }

  Future<UserModel?> signIn(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final fb.User? fbUser = result.user;
    if (fbUser != null) {
      return UserModel.fromFirebaseUser(fbUser);
    }
    return null;
  }

  Future<UserModel?> signUp(String email, String password) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final fb.User? fbUser = result.user;
    if (fbUser != null) {
      return UserModel.fromFirebaseUser(fbUser);
    }
    return null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
