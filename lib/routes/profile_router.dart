import 'package:foodbook_beta/features/auth/presentation/pages/profile_pages.dart';
import 'package:foodbook_beta/features/save/presentation/save_pages.dart';
import 'package:go_router/go_router.dart';

final List<GoRoute> profileRoute = [
  GoRoute(
    path: '/profile',
    name: 'profile',
    builder: (context, state) => ProfilePages(),
    routes: [
      GoRoute(
        path: '/saved',
        name: 'save',
        builder: (context, state) => SavedPage(),
      ),
    ],
  ),
];
