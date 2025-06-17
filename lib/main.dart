import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'features/on_boarding/presentation/on_boarding_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flutter Theme App",
      theme: AppTheme.lightTheme,
      home: OnBoardingScreen(),
    );
  }
}
