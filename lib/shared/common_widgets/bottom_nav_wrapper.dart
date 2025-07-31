// lib/widgets/bottom_nav_wrapper.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'bottom_nav_bar.dart';

class BottomNavWrapper extends StatelessWidget {
  final Widget child;

  const BottomNavWrapper({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final location = GoRouter.of(
      context,
    ).routerDelegate.currentConfiguration.fullPath;

    int getIndex() {
      if (location.startsWith('/swipe')) return 0;
      if (location.startsWith('/surfen')) return 1;
      if (location.startsWith('/add')) return 2;
      if (location.startsWith('/book')) return 3;
      if (location.startsWith('/profile')) return 4;
      return 0; // default to swipe
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavBar(currentIndex: getIndex()),
    );
  }
}
