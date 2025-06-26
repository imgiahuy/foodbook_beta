import 'package:flutter/material.dart';
import 'package:foodbook_beta/core/app_assets/app_texts.dart';
import 'package:foodbook_beta/core/app_assets/image_assets.dart';
import 'package:foodbook_beta/core/theme/app_theme/text_theme.dart';
import 'package:foodbook_beta/core/theme/colors/colors_digital.dart';
import 'package:go_router/go_router.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: yellow,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          children: [
            Positioned(
              right: screenWidth * 0.15,
              top: screenHeight * 0.1,
              child: Container(
                decoration: BoxDecoration(shape: BoxShape.circle, color: white),
                height: screenWidth * 0.25,
                width: screenWidth * 0.25,
                child: Center(
                  child: Image.asset(AppAssets.logo, fit: BoxFit.contain),
                ),
              ),
            ),
            Positioned(
              child: Center(
                child: Image.asset(
                  AppAssets.foodplate_1,
                  fit: BoxFit.cover,
                  height: screenWidth * 0.9,
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.009,
              left: screenWidth * 0,
              child: Container(
                padding: EdgeInsets.all(15),
                height: screenWidth * 0.7,
                width: screenWidth * 0.7,
                child: Center(
                  child: Text(
                    AppTexts.whatEatToday,
                    style: AppTextTheme.textTheme.displayLarge,
                  ),
                ),
              ),
            ),
            Positioned(
              right: screenWidth * -0.015,
              bottom: screenHeight * -0.12,
              child: SizedBox(
                child: Image.asset(
                  AppAssets.menThinking,
                  height: screenHeight * 0.75,
                  width: screenWidth * 0.75,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              left: screenWidth * 0.12,
              right: screenWidth * 0.12,
              bottom: screenHeight * 0.05,
              child: SizedBox(
                height: screenWidth * 0.15,
                child: ElevatedButton(
                  onPressed: () {
                    context.goNamed('welcome');
                  },
                  child: Text(AppTexts.getStarted),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
