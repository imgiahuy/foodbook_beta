import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodbook_beta/features/auth/presentation/controller/profile_controller.dart';
import 'package:foodbook_beta/shared/common_widgets/bottom_nav_bar.dart';
import 'package:foodbook_beta/shared/design_system/app_const.dart';
import 'package:foodbook_beta/shared/design_system/text_theme.dart';
import 'package:foodbook_beta/shared/design_system/colors_digital.dart';
import 'package:foodbook_beta/features/auth/presentation/widgets/avatar.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:foodbook_beta/features/auth/presentation/states/avatar_notifier.dart';

class ProfilePages extends ConsumerWidget {
  const ProfilePages({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ProfileController(ref);

    final user = controller.readAuthState();

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      bottomNavigationBar: BottomNavBar(currentIndex: 4),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 4,
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSizes.mediumSpacing,
                      AppSizes.mediumPadding,
                      0,
                      0,
                    ),
                    child: Text(
                      'Hi, there',
                      style: AppTextTheme.textTheme.displayMedium,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: yellow,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(AppSizes.cornerRadius),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: screenHeight * 0.2,
            left: screenWidth * 0.1,
            right: screenWidth * 0.1,
            bottom: 0,
            child: Column(
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: antiqueWhite,
                      borderRadius: BorderRadius.circular(
                        AppSizes.cornerRadius,
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Avatar(
                          onTap: () async {
                            final picker = ImagePicker();
                            final pickedFile = await picker.pickImage(
                              source: ImageSource.gallery,
                            );
                            if (pickedFile != null) {
                              final file = File(pickedFile.path);
                              ref.read(avatarFileProvider.notifier).state =
                                  file;
                            }
                          },
                        ),
                        SizedBox(
                          height: 50, // fixed height
                          child: Center(
                            child: Text(
                              user != null ? (user.username ?? 'User') : 'User',
                              style: AppTextTheme.textTheme.labelLarge,
                              maxLines: 1,
                              overflow:
                                  TextOverflow.ellipsis, // Prevent overflow
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(
                          child: TextButton(
                            onPressed: () {},
                            child: Text('Edit'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: AppSizes.buttonHeight,
                          width: AppSizes.buttonWidthLarge,
                          child: ElevatedButton(
                            onPressed: () {
                              context.goNamed('save');
                            },
                            child: Row(
                              children: [
                                Expanded(child: Text('Saved')),
                                Icon(Icons.chevron_right_outlined),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: AppSizes.buttonHeight,
                          width: AppSizes.buttonWidthLarge,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Row(
                              children: [
                                Expanded(child: Text('Setting')),
                                Icon(Icons.chevron_right_outlined),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: AppSizes.buttonHeight,
                          width: AppSizes.buttonWidthLarge,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Row(
                              children: [
                                Expanded(child: Text('History')),
                                Icon(Icons.chevron_right_outlined),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: AppSizes.buttonHeight,
                          width: AppSizes.buttonWidthLarge,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Row(
                              children: [
                                Expanded(child: Text('Help')),
                                Icon(Icons.chevron_right_outlined),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: AppSizes.buttonHeight,
                          width: AppSizes.buttonWidthLarge,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: orange,
                              foregroundColor: white,
                            ),
                            onPressed: () {
                              controller.signOut(context);
                            },
                            child: Row(
                              children: [
                                Expanded(child: Text('Sign out')),
                                Icon(Icons.chevron_right_outlined),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
