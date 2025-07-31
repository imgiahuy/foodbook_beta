import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart'; // Add this dependency
import 'package:foodbook_beta/features/auth/presentation/controller/register_controller.dart';
import 'package:foodbook_beta/shared/design_system/app_const.dart';
import 'package:foodbook_beta/shared/design_system/text_theme.dart';
import 'package:foodbook_beta/shared/design_system/colors_digital.dart';
import 'package:foodbook_beta/features/auth/presentation/feature_assets/custom_text.dart';
import 'package:foodbook_beta/features/auth/presentation/feature_assets/image_path.dart';
import 'package:go_router/go_router.dart';

class RegisterPages extends ConsumerStatefulWidget {
  RegisterPages({super.key});

  @override
  ConsumerState<RegisterPages> createState() => _RegisterPagesState();
}

class _RegisterPagesState extends ConsumerState<RegisterPages> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();

  File? _avatarFile;

  Future<void> _pickAvatarImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _avatarFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = RegisterController(ref);
    final authState = controller.watchAuthState();
    final isChecked = controller.watchTerm();

    controller.listenRegisterState(context);

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
              CustomText.signIn,
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
                  CustomText.signUp,
                  style: AppTextTheme.textTheme.headlineLarge,
                ),
                Padding(
                  padding: EdgeInsets.all(AppSizes.smallSpacing),
                  child: Text(
                    CustomText.decorText1,
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

                  GestureDetector(
                    onTap: () => _pickAvatarImage(),
                    child: CircleAvatar(
                      radius: 50, // or use AppSizes.circleLogoSize/2
                      backgroundColor: yellow,
                      backgroundImage: _avatarFile != null
                          ? FileImage(_avatarFile!)
                          : null,
                      child: _avatarFile == null
                          ? Icon(
                              Icons.add_a_photo,
                              size: 40,
                              color: Colors.grey[700],
                            )
                          : null,
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
                            controller: passwordController,
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
                                    controller.checkTermIcon(isChecked),
                                  ),
                                  onPressed: () {
                                    controller.checkTerm(isChecked);
                                  },
                                ),
                                Expanded(
                                  child: Text(
                                    CustomText.termNoti,
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
                            onPressed: () {
                              final email = emailController.text.trim();
                              final password = passwordController.text.trim();
                              final username = usernameController.text.trim();
                              controller.signUp(
                                email,
                                password,
                                username,
                                isChecked,
                                authState,
                                _avatarFile, // pass the avatar file here
                              );
                            },
                            child: controller.authStateLoadingCheck(authState),
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
