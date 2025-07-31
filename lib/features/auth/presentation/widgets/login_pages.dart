import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodbook_beta/features/auth/presentation/controller/login_controller.dart';
import 'package:foodbook_beta/features/auth/presentation/states/auth_provider.dart';
import 'package:foodbook_beta/shared/design_system/app_const.dart';
import 'package:foodbook_beta/shared/design_system/text_theme.dart';
import 'package:foodbook_beta/shared/design_system/colors_digital.dart';
import 'package:foodbook_beta/features/auth/presentation/feature_assets/custom_text.dart';
import 'package:foodbook_beta/features/auth/presentation/feature_assets/image_path.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/user.dart';

class LoginPages extends ConsumerWidget {
  LoginPages({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = AuthController(ref);
    ref.listen<AsyncValue<User?>>(authNotifierProvider, (previous, next) {
      next.whenOrNull(
        data: (user) {
          if (user != null) {
            context.go('/surfen');
          }
        },
        error: (error, stackTrace) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
        },
      );
    });

    final authState = controller.watchAuthState();

    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.goNamed('welcome');
          },
          icon: Transform.flip(
            flipX: true,
            child: Icon(Icons.arrow_right_alt_sharp),
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: AppSizes.spacing),
            child: Text(
              CustomText.signUp,
              style: AppTextTheme.textTheme.headlineSmall,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: screenWidth * 0.4,
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(AppSizes.spacing, 0, 0, 0),
            decoration: BoxDecoration(
              color: yellow,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(AppSizes.cornerRadius),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppSizes.spacing),
                Text(
                  CustomText.signIn,
                  style: AppTextTheme.textTheme.headlineLarge,
                ),
                SizedBox(height: AppSizes.spacing),
                Text(
                  CustomText.signUpEncourage,
                  textAlign: TextAlign.left,
                  style: AppTextTheme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(AppSizes.cornerRadius),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: AppSizes.largeSpacing),
                    controller.circleAvatarDef(),
                    SizedBox(height: AppSizes.largeSpacing),
                    SizedBox(
                      height: screenWidth * 1.1,
                      width: double.infinity,
                      child: Column(
                        children: [
                          SizedBox(
                            width: AppSizes.textFormFieldSize,
                            child: TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.cornerRadius,
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'Email addresse',
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          SizedBox(height: AppSizes.mediumSpacing),
                          SizedBox(
                            width: AppSizes.textFormFieldSize,
                            child: TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.cornerRadius,
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'Password',
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          SizedBox(height: AppSizes.smallSpacing),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.fromLTRB(
                              AppSizes.largePadding,
                              0,
                              0,
                              0,
                            ),
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                'Forgot password ?',
                                style: AppTextTheme.textTheme.labelSmall,
                              ),
                            ),
                          ),
                          SizedBox(height: AppSizes.smallSpacing),
                          SizedBox(
                            height: AppSizes.buttonHeight,
                            width: AppSizes.buttonWidthLarge,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.cornerRadius,
                                  ),
                                ),
                              ),
                              onPressed: () => controller.signIn(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                              ),
                              child: controller.authStateLoadingCheck(
                                authState,
                              ),
                            ),
                          ),
                          SizedBox(height: AppSizes.spacing),
                          SizedBox(
                            child: Text(
                              'or',
                              textAlign: TextAlign.center,
                              style: AppTextTheme.textTheme.bodyMedium,
                            ),
                          ),
                          SizedBox(height: AppSizes.spacing),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: AppSizes.buttonHeight,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: white,
                                    shape: CircleBorder(),
                                  ),
                                  onPressed: () {},
                                  child: Image.asset(
                                    ImagePath.googleIcon,
                                    fit: BoxFit.contain,
                                    height: AppSizes.roundedButton,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: AppSizes.buttonHeight,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: white,
                                    shape: CircleBorder(),
                                  ),
                                  onPressed: () {},
                                  child: Image.asset(
                                    ImagePath.metaIcon,
                                    fit: BoxFit.contain,
                                    height: 30,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: AppSizes.buttonHeight,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: white,
                                    shape: CircleBorder(),
                                  ),
                                  onPressed: () {},
                                  child: Image.asset(
                                    ImagePath.appleIcon,
                                    fit: BoxFit.contain,
                                    height: AppSizes.roundedButton,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
