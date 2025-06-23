// on_boarding_router.dart
import 'package:foodbook_beta/features/auth/presentation/login_pages.dart';
import 'package:foodbook_beta/features/auth/presentation/register_pages.dart';
import 'package:go_router/go_router.dart';
import 'package:foodbook_beta/features/on_boarding/presentation/on_boarding_screen.dart';
import 'package:foodbook_beta/features/auth/presentation/welcome_pages.dart';

final List<GoRoute> onBoardingRoutes = [
  GoRoute(
    path: '/',
    builder: (context, state) => const OnBoardingScreen(),
    routes: [
      GoRoute(
        path: 'welcome',
        name: 'welcome',
        builder: (context, state) => WelcomePages(),
        routes: [
          GoRoute(path: 'signin', builder: (context, state) => LoginPages()),
          GoRoute(path: 'signup', builder: (context, state) => RegisterPages()),
        ],
      ),
    ],
  ),
];
