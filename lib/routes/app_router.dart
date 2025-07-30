// on_boarding_router.dart
import 'package:foodbook_beta/features/auth/presentation/widgets/login_pages.dart';
import 'package:foodbook_beta/features/auth/presentation/widgets/profile_pages.dart';
import 'package:foodbook_beta/features/auth/presentation/widgets/register_pages.dart';
import 'package:foodbook_beta/features/posten/presentation/widgets/post_editor_page.dart';
import 'package:foodbook_beta/features/posten/presentation/widgets/surfen_page.dart';
import 'package:foodbook_beta/features/posten/presentation/widgets/swipe_page.dart';
import 'package:go_router/go_router.dart';
import 'package:foodbook_beta/features/onboarding/widgets/on_boarding_screen.dart';
import 'package:foodbook_beta/features/auth/presentation/widgets/welcome_pages.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'onboarding',
      builder: (context, state) => OnBoardingScreen(),
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
    GoRoute(
      path: '/surfen',
      name: 'surfen',
      builder: (context, state) => SurfenPage(),
      routes: [
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => ProfilePages(),
        ),
        GoRoute(
          path: '/swipe',
          name: 'swipe',
          builder: (context, state) => SwipePage(),
        ),
        GoRoute(
          path: '/add',
          name: 'add',
          builder: (context, state) => PostEditor(),
        ),
      ],
    ),
  ],
);
