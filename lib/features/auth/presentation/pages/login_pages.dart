import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodbook_beta/core/app_assets/app_texts.dart';
import 'package:foodbook_beta/core/app_assets/image_assets.dart';
import 'package:foodbook_beta/core/theme/app_theme/app_const.dart';
import 'package:foodbook_beta/core/theme/app_theme/app_theme.dart';
import 'package:foodbook_beta/core/theme/app_theme/text_theme.dart';
import 'package:foodbook_beta/core/theme/colors/colors_digital.dart';
import 'package:foodbook_beta/features/auth/domain/entities/user.dart';
import 'package:foodbook_beta/features/auth/logic/auth_provider.dart';
import 'package:go_router/go_router.dart';

//!Later will change and add feature to change the avatar of known users. (Stateful Widget)

class LoginPages extends ConsumerWidget {
  LoginPages({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    ref.listen<AsyncValue<User?>>(authNotifierProvider, (previous, next) {
      next.whenOrNull(
        data: (user) {
          if (user != null) {
            // Navigate to home page on successful sign-in
            context.goNamed(
              'home',
            ); // or pushReplacementNamed if using Navigator
          }
        },
        error: (error, stackTrace) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
        },
      );
    });

    final screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: Scaffold(
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
                AppTexts.signUp,
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
                    AppTexts.signIn,
                    style: AppTextTheme.textTheme.headlineLarge,
                  ),
                  SizedBox(height: AppSizes.spacing),
                  Text(
                    AppTexts.signUpEncourage,
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
                  //padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      SizedBox(height: AppSizes.largeSpacing),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: yellow,
                        ),
                        height: AppSizes.circleLogoSize,
                        width: double.infinity,
                        child: Center(
                          child: Image.asset(
                            AppAssets.logo,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
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
                                /*style: ButtonStyle(
                                  overlayColor: WidgetStateProperty.all(
                                    Colors.transparent,
                                  ),
                                ),*/
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
                                onPressed: () {
                                  final email = emailController.text.trim();
                                  final password = passwordController.text
                                      .trim();
                                  ref
                                      .read(authNotifierProvider.notifier)
                                      .signIn(email, password);
                                },
                                child: authState.isLoading
                                    ? CircularProgressIndicator(color: white)
                                    : Text(AppTexts.signIn),
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
                                      AppAssets.googleIcon,
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
                                      AppAssets.metaIcon,
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
                                      AppAssets.appleIcon,
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
      ),
    );
  }
}
