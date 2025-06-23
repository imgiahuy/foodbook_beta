import 'package:flutter/material.dart';
import 'package:foodbook_beta/core/theme/app_theme/text_theme.dart';
import 'package:foodbook_beta/core/theme/colors/colors_digital.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
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
      iconTheme: IconThemeData(color: black),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: black,
        foregroundColor: white,
        elevation: 1, //drop shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(30),
        ),
        textStyle: AppTextTheme.textTheme.labelMedium,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: black,
      //indicatorColor: adjust later,
      labelTextStyle: WidgetStateProperty.all(
        TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: white),
      ),
      iconTheme: WidgetStateProperty.all(
        IconThemeData(
          color: white,
          //size will be adjust later,
        ),
      ),
    ),
  );
}
