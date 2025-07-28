import 'package:flutter/material.dart';
import 'package:foodbook_beta/shared/design_system/colors_digital.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/gridicons.dart';
import 'package:iconify_flutter/icons/healthicons.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  const BottomNavBar({super.key, required this.currentIndex});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: black,
      currentIndex: widget.currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/swipe');
            break;
          case 1:
            context.go('/home');
            break;
          case 2:
            context.go('/add');
            break;
          case 3:
            context.go('/like');
            break;
          case 4:
            context.go('/profile');
            break;
        }
      },
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      unselectedFontSize: 14, //by default
      items: [
        BottomNavigationBarItem(
          icon: Iconify(Gridicons.story, color: white),
          label: 'Swipe',
        ),
        BottomNavigationBarItem(
          icon: Iconify(Healthicons.home_alt_outline, color: white),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Iconify(Gridicons.add, color: white),
          label: 'Add',
        ),
        BottomNavigationBarItem(
          icon: Iconify(Gridicons.heart_outline, color: white),
          label: 'Liked',
        ),
        BottomNavigationBarItem(
          icon: Iconify(Healthicons.ui_user_profile_outline, color: white),
          label: 'Profile',
        ),
      ],
      type: BottomNavigationBarType.fixed,
    );
  }
}
