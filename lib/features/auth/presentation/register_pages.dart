import 'package:flutter/material.dart';
import 'package:foodbook_beta/core/app_assets/app_texts.dart';
import 'package:foodbook_beta/core/app_assets/image_assets.dart';
import 'package:foodbook_beta/core/theme/app_theme/app_const.dart';
import 'package:foodbook_beta/core/theme/app_theme/app_theme.dart';
import 'package:foodbook_beta/core/theme/app_theme/text_theme.dart';
import 'package:foodbook_beta/core/theme/colors/colors_digital.dart';
import 'package:go_router/go_router.dart';

class RegisterPages extends StatelessWidget {
  const RegisterPages({super.key});

  @override
  Widget build(BuildContext context) {
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
                child: SingleChildScrollView(
                  //padding: EdgeInsets.all(10),
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
                          child: Image.asset(
                            AppAssets.logo,
                            fit: BoxFit.contain,
                          ),
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
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppSizes.cornerRadius,
                                    ),
                                    borderSide: BorderSide.none,
                                  ),
                                  hintText: 'User name',
                                ),
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ),
                            SizedBox(height: AppSizes.spacing),
                            SizedBox(
                              width: AppSizes.textFormFieldSize,
                              child: TextFormField(
                                obscureText: false,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: white,
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
                            SizedBox(height: AppSizes.spacing),
                            //! add an accept button here
                            SizedBox(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.domain_verification_rounded),
                                  Text(
                                    AppTexts.termNoti,
                                    style: AppTextTheme.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: AppSizes.spacing),
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
                                onPressed: () {},
                                child: Text(AppTexts.signUp),
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
                                      height:
                                          30, //!really specific because the meta logo is bigger than others here
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
