import 'package:flutter/material.dart';
import 'package:foodbook_beta/core/theme/app_theme/app_const.dart';
import 'package:foodbook_beta/core/theme/app_theme/text_theme.dart';
import 'package:foodbook_beta/core/theme/colors/colors_digital.dart';

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
        elevation: 1, //drop shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(AppSizes.cornerRadius),
        ),
        textStyle: AppTextTheme.textTheme.labelMedium,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: black,
      //indicatorColor: adjust later.
      iconTheme: WidgetStateProperty.all(
        IconThemeData(
          color: white,
          //size will be adjust later,
        ),
      ),
    ),
  );
}
