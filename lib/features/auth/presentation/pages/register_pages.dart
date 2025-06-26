import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodbook_beta/core/app_assets/app_texts.dart';
import 'package:foodbook_beta/core/app_assets/image_assets.dart';
import 'package:foodbook_beta/core/theme/app_theme/app_const.dart';
import 'package:foodbook_beta/core/theme/app_theme/text_theme.dart';
import 'package:foodbook_beta/core/theme/colors/colors_digital.dart';
import 'package:foodbook_beta/features/auth/domain/entities/user.dart';
import 'package:foodbook_beta/features/auth/logic/auth_provider.dart';
import 'package:go_router/go_router.dart';

class RegisterPages extends ConsumerWidget {
  RegisterPages({super.key});

  final emailController = TextEditingController();
  final passwordCotroller = TextEditingController();
  final usernameController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final isChecked = ref.watch(termsAcceptedProvider);

    ref.listen<AsyncValue<User?>>(authNotifierProvider, (previous, next) {
      next.whenOrNull(
        data: (user) {
          if (user != null) {
            // Navigate to home page on successful sign-in
            context.goNamed(
              'signin',
            ); // or pushReplacementNamed if using Navigator
          }
        },
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Sign up failed: ${error.toString()}")),
          );
        },
      );
    });

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
              AppTexts.signIn,
              style: AppTextTheme.textTheme.headlineSmall,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: screenWidth * 0.3,
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
                  AppTexts.signUp,
                  style: AppTextTheme.textTheme.headlineLarge,
                ),
                Padding(
                  padding: EdgeInsetsGeometry.all(AppSizes.smallSpacing),
                  child: Text(
                    AppTexts.decorText1,
                    style: AppTextTheme.textTheme.bodyMedium,
                  ),
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
              child: Column(
                children: [
                  SizedBox(height: AppSizes.spacing),
                  //! feature to let people choose their avatar.
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: yellow,
                    ),
                    height: AppSizes.circleLogoSize,
                    width: double.infinity,
                    child: Center(
                      child: Image.asset(AppAssets.logo, fit: BoxFit.contain),
                    ),
                  ),
                  SizedBox(height: AppSizes.mediumSpacing),
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
                              fillColor: antiqueWhite,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppSizes.cornerRadius,
                                ),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'Email adresse',
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        SizedBox(height: AppSizes.spacing),
                        SizedBox(
                          width: AppSizes.textFormFieldSize,
                          child: TextFormField(
                            controller: passwordCotroller,
                            obscureText: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: antiqueWhite,
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
                        SizedBox(height: AppSizes.spacing),
                        SizedBox(
                          width: AppSizes.textFormFieldSize,
                          child: TextFormField(
                            controller: usernameController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: antiqueWhite,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppSizes.cornerRadius,
                                ),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'User name',
                            ),
                          ),
                        ),
                        SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.all(
                              AppSizes.mediumSpacing,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    isChecked
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank,
                                  ),
                                  onPressed: () {
                                    ref
                                            .read(
                                              termsAcceptedProvider.notifier,
                                            )
                                            .state =
                                        !isChecked;
                                  },
                                ),
                                Expanded(
                                  child: Text(
                                    AppTexts.termNoti,
                                    style: AppTextTheme.textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
                            onPressed: isChecked && !authState.isLoading
                                ? () {
                                    final email = emailController.text.trim();
                                    final password = passwordCotroller.text
                                        .trim();
                                    final username = usernameController.text
                                        .trim();
                                    ref
                                        .read(authNotifierProvider.notifier)
                                        .signUp(email, password, username);
                                  }
                                : null,
                            child: authState.isLoading
                                ? CircularProgressIndicator(color: white)
                                : Text(AppTexts.signUp),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
