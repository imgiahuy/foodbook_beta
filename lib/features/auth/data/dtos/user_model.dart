import '../../domain/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

class UserModel extends User {
  const UserModel({
    required super.uid,
    required super.email,
    super.username,
    super.avatar,
  });

  factory UserModel.fromFirebaseUser(fb.User fbUser, {String? username, String? avatar}) {
    return UserModel(
      uid: fbUser.uid,
      email: fbUser.email ?? '',
      username: username,
      avatar: avatar,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      username: json['username'],
      avatar: json['avatar'],
    );
  }

  User toEntity() => User(
        uid: uid,
        email: email,
        username: username,
        avatar: avatar,
      );

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'avatar': avatar,
    };
  }
}
