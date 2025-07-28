import 'package:flutter/material.dart';
import 'package:foodbook_beta/shared/design_system/app_const.dart';
import 'package:foodbook_beta/shared/design_system/text_theme.dart';
import 'package:foodbook_beta/shared/design_system/colors_digital.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: white,
    brightness: Brightness.light,
    fontFamily: 'Poppins',
    colorScheme: ColorScheme.fromSeed(seedColor: yellow),
    appBarTheme: AppBarTheme(
      backgroundColor: yellow,
      foregroundColor: black,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: black,
      ),
      iconTheme: IconThemeData(color: black, size: 40),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: black,
        foregroundColor: white,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(AppSizes.cornerRadius),
        ),
        textStyle: AppTextTheme.textTheme.labelMedium,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: black,
      iconTheme: WidgetStateProperty.all(IconThemeData(color: white)),
    ),
  );
}
