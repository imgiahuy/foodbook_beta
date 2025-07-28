import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodbook_beta/features/auth/domain/models/user.dart';
import 'package:foodbook_beta/features/auth/presentation/states/auth_provider.dart';
import 'package:go_router/go_router.dart';

class ProfileController {
  WidgetRef ref;
  ProfileController(this.ref);

  void signOut(BuildContext context) async {
    try {
      await ref.read(authNotifierProvider.notifier).signOut();
      context.goNamed('welcome');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Logout failed: $e')));
    }
  }

  User? readAuthState() {
    return ref.read(authNotifierProvider).value;
  }
}
