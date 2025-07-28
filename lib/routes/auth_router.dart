// on_boarding_router.dart
import 'package:foodbook_beta/features/auth/presentation/widgets/login_pages.dart';
import 'package:foodbook_beta/features/auth/presentation/widgets/register_pages.dart';
import 'package:go_router/go_router.dart';
import 'package:foodbook_beta/features/onboarding/widgets/on_boarding_screen.dart';
import 'package:foodbook_beta/features/auth/presentation/widgets/welcome_pages.dart';

final List<GoRoute> authRouter = [
  GoRoute(
    path: '/',
    builder: (context, state) => const OnBoardingScreen(),
    routes: [
      GoRoute(
        path: 'welcome',
        name: 'welcome',
        builder: (context, state) => WelcomePages(),
        routes: [
          GoRoute(
            path: 'signin',
            name: 'signin',
            builder: (context, state) => LoginPages(),
          ),
          GoRoute(
            path: 'signup',
            name: 'signup',
            builder: (context, state) => RegisterPages(),
          ),
        ],
      ),
    ],
  ),
];
