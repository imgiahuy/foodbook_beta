// lib/routes/shell_router.dart
import 'package:foodbook_beta/shared/widgets/bottom_nav_wrapper.dart';
import 'package:foodbook_beta/routes/add_router.dart';
import 'package:foodbook_beta/routes/home_route.dart';
import 'package:foodbook_beta/routes/like_router.dart';
import 'package:foodbook_beta/routes/swipe_router.dart';
import 'package:go_router/go_router.dart';
import 'package:foodbook_beta/routes/profile_router.dart';

final List<RouteBase> shellRoutes = [
  ShellRoute(
    builder: (context, state, child) => BottomNavWrapper(child: child),
    routes: [
      ...homeRoutes,
      ...profileRoute,
      ...addRoutes,
      ...swipeRoutes,
      ...likeRoutes,
    ],
  ),
];
