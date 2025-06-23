import 'package:flutter/material.dart';
import 'package:foodbook_beta/core/app_assets/app_texts.dart';
import 'package:foodbook_beta/core/app_assets/image_assets.dart';
import 'package:foodbook_beta/core/theme/app_theme/app_const.dart';
import 'package:foodbook_beta/core/theme/app_theme/app_theme.dart';
import 'package:foodbook_beta/core/theme/app_theme/text_theme.dart';
import 'package:foodbook_beta/core/theme/colors/colors_digital.dart';
import 'package:go_router/go_router.dart';

class WelcomePages extends StatelessWidget {
  const WelcomePages({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: Scaffold(
        backgroundColor: white,
        body: Stack(
          children: [
            Positioned(
              top: screenHeight * 0.25,
              right: 0,
              left: 0,
              bottom: 0,
              child: SizedBox(
                //height : 200 //might effect the column.
                width: double.infinity,
                child: Column(
                  children: [
                    Container(
                      height: AppSizes.circleLogoSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: yellow,
                      ),
                      child: Image.asset(AppAssets.logo),
                    ),
                    SizedBox(height: AppSizes.spacing),
                    Text(
                      AppTexts.brandNameCap,
                      style: AppTextTheme.textTheme.displayMedium,
                    ),
                    Text(
                      AppTexts.brandDef,
                      style: AppTextTheme.textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.65,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: yellow,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppSizes.cornerRadius),
                  ),
                ),
                child: Column(
                  children: [
                    //easter egg when scroll up ???
                    Padding(
                      padding: const EdgeInsets.all(AppSizes.sectionPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppTexts.welcome,
                            style: AppTextTheme.textTheme.headlineMedium,
                          ),
                          Text(
                            AppTexts.facts[0],
                            style: AppTextTheme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: AppSizes.buttonHeight,
                          width: AppSizes.buttonWidth,
                          child: ElevatedButton(
                            onPressed: () {
                              context.goNamed('signin');
                            },
                            child: Text(AppTexts.signIn),
                          ),
                        ),
                        SizedBox(width: AppSizes.largeSpacing),
                        SizedBox(
                          height: AppSizes.buttonHeight,
                          width: AppSizes.buttonWidth,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: white,
                              foregroundColor: black,
                            ),
                            onPressed: () {
                              context.goNamed('signup');
                            },
                            child: Text(AppTexts.signUp),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: screenWidth - 800,
              top: screenHeight - 1000,
              left: 0,
              child: Container(
                height: AppSizes.esclipeDecor,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: yellow,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
