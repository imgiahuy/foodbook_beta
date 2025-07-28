import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodbook_beta/features/auth/domain/models/user.dart';
import 'package:foodbook_beta/features/auth/presentation/feature_assets/custom_text.dart';
import 'package:foodbook_beta/features/auth/presentation/feature_assets/image_path.dart';
import 'package:foodbook_beta/features/auth/presentation/states/auth_provider.dart';
import 'package:foodbook_beta/features/auth/presentation/states/avatar_notifier.dart';
import 'package:foodbook_beta/shared/design_system/app_const.dart';
import 'package:foodbook_beta/shared/design_system/colors_digital.dart';
import 'package:go_router/go_router.dart';

class AuthController {
  final WidgetRef ref;

  AuthController(this.ref);

  void signIn(String email, String password) {
    ref.read(authNotifierProvider.notifier).signIn(email, password);
  }

  void listenAuthState(BuildContext context) {
    ref.listen<AsyncValue<User?>>(authNotifierProvider, (previous, next) {
      next.whenOrNull(
        data: (user) {
          if (user != null) {
            context.goNamed('home');
          }
        },
        error: (error, _) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
        },
      );
    });
  }

  AsyncValue<User?> watchAuthState() {
    return ref.watch(authNotifierProvider);
  }

  File? watchAvatarState() {
    return ref.watch(avatarFileProvider);
  }

  CircleAvatar circleAvatarDef(File? avatarState) {
    return CircleAvatar(
      backgroundImage: avatarState == null
          ? AssetImage(ImagePath.logo)
          : FileImage(avatarState),
      backgroundColor: yellow,
      radius: AppSizes.circleLogoSize - 40,
    );
  }

  Widget authStateLoadingCheck(AsyncValue<User?> authState) {
    if (authState.isLoading) {
      return CircularProgressIndicator(color: white);
    } else {
      return Text(CustomText.signIn);
    }
  }
}
