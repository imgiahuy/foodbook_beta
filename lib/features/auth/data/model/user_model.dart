import '../../domain/entities/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

class UserModel extends User {
  const UserModel({required super.uid, required super.email});

  //to convert from firebase user to user
  factory UserModel.fromFirebaseUser(fb.User fbUser) {
    return UserModel(uid: fbUser.uid, email: fbUser.email ?? '');
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(uid: json['uid'], email: json['email']);
  }

  User toEntity() => User(uid: uid, email: email);

  Map<String, dynamic> toJson() {
    return {'uid': uid, 'email': email};
  }
}
