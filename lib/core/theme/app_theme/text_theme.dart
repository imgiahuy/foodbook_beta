import 'package:flutter/material.dart';
import 'package:foodbook_beta/core/theme/colors/colors_digital.dart';

class AppTextTheme {
  static final fonts = 'Poppins';
  static final TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(
      fontFamily: fonts,
      fontSize: 70,
      height: 0.9,
      fontWeight: FontWeight.w600,
      color: orange,
    ),
    displayMedium: TextStyle(
      fontSize: 40,
      height: 0.9,
      fontWeight: FontWeight.w700,
      color: orange,
      fontFamily: fonts,
    ),
    //
    headlineMedium: TextStyle(
      fontSize: 35,
      fontWeight: FontWeight.w700,
      color: orange,
      fontFamily: fonts,
    ),
    headlineLarge: TextStyle(
      color: orange,
      fontSize: 40,
      fontWeight: FontWeight.w600,
      fontFamily: fonts,
    ),
    headlineSmall: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
    //
    labelMedium: TextStyle(
      fontFamily: fonts,
      fontSize: 21,
      fontWeight: FontWeight.w600,
      color: white,
    ),
    labelSmall: TextStyle(
      color: orange,
      fontSize: 17,
      fontWeight: FontWeight.w400,
      fontFamily: fonts,
    ),
    //
    bodyMedium: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      fontFamily: fonts,
      color: black,
    ),
    bodyLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      fontFamily: fonts,
    ),
    bodySmall: TextStyle(),
  );
}
