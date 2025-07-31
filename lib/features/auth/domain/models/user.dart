class User {
  final String uid;
  final String email;
  final String? username;
  final String? avatar;

  const User({required this.uid, required this.email, this.username, this.avatar
  });
}
