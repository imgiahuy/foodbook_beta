import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodbook_beta/features/auth/domain/models/user.dart';
import 'package:foodbook_beta/features/auth/presentation/feature_assets/custom_text.dart';
import 'package:foodbook_beta/features/auth/presentation/states/auth_provider.dart';
import 'package:foodbook_beta/shared/design_system/colors_digital.dart';
import 'package:go_router/go_router.dart';

class RegisterController {
  WidgetRef ref;
  RegisterController(this.ref);

  void listenRegisterState(BuildContext context) {
    ref.listen<AsyncValue<User?>>(authNotifierProvider, (previous, next) {
      next.whenOrNull(
        data: (user) {
          if (user != null) {
            context.goNamed('signin');
          }
        },
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Sign up failed:${error.toString()}")),
          );
        },
      );
    });
  }

  void signUp(
    String email,
    String password,
    String username,
    bool isChecked,
    AsyncValue<User?> authState,
  ) {
    if (isChecked && !authState.isLoading) {
      ref.read(authNotifierProvider.notifier).signUp(email, password, username);
    }
  }

  AsyncValue<User?> watchAuthState() {
    return ref.watch(authNotifierProvider);
  }

  bool watchTerm() {
    return ref.watch(termsAcceptedProvider);
  }

  void checkTerm(bool isCheck) {
    ref.read(termsAcceptedProvider.notifier).state = !isCheck;
  }

  IconData checkTermIcon(bool isCheck) {
    if (isCheck) {
      return Icons.check_box;
    } else {
      return Icons.check_box_outline_blank;
    }
  }

  Widget authStateLoadingCheck(AsyncValue<User?> authState) {
    if (authState.isLoading) {
      return CircularProgressIndicator(color: white);
    } else {
      return Text(CustomText.signUp);
    }
  }
}
