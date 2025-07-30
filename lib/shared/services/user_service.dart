import 'package:foodbook_beta/features/auth/domain/models/user.dart';

abstract class UserService {
  String? getCurrentUserId();
  User? getUser(String? id);
}
