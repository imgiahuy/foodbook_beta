import 'package:flutter/material.dart';

//Define a Theme for the whole App for better update

class AppTheme {
  //Theme color
  static final _colorSchemaLight = ColorScheme.fromSeed(
    seedColor: Color.fromARGB(255, 241, 184, 14),
    brightness: Brightness.light,
  );

  //!Still in progress
  static final _colorSchemaDark = ColorScheme.fromSeed(
    seedColor: Color.fromARGB(97, 0, 0, 0),
    brightness: Brightness.dark,
  );

  //Theme fonts
  //!Update later

  //Light mode Theme
  static final lightTheme = ThemeData(
    colorScheme: _colorSchemaLight,
    appBarTheme: AppBarTheme(
      backgroundColor: _colorSchemaLight.primary,
      foregroundColor: _colorSchemaLight.onPrimary,
      centerTitle: true,
    ),
    //?scaffoldBackgroundColor:,
  );

  //Dark mode Theme
  static final darkTheme = ThemeData(
    colorScheme: _colorSchemaDark,
    appBarTheme: AppBarTheme(
      backgroundColor: Color.fromARGB(97, 0, 0, 0),
      foregroundColor: Color.fromARGB(255, 252, 252, 252),
      centerTitle: true,
    ),
    iconTheme: IconThemeData(color: Color.fromARGB(255, 255, 106, 0)),
  );
}
