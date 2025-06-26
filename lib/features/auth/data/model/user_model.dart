import '../../domain/entities/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

class UserModel extends User {
  const UserModel({required super.uid, required super.email, super.username});

  factory UserModel.fromFirebaseUser(fb.User fbUser, {String? username}) {
    return UserModel(
      uid: fbUser.uid,
      email: fbUser.email ?? '',
      username: username,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      username: json['username'],
    );
  }

  User toEntity() => User(uid: uid, email: email, username: username);

  Map<String, dynamic> toJson() {
    return {'uid': uid, 'email': email, 'username': username};
  }
}
