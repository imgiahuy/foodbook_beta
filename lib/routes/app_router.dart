import 'package:foodbook_beta/routes/auth_router.dart';
import 'package:foodbook_beta/routes/onBoarding_router.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  //should use list of GoRoute to build modularized routes
  routes: [...onBoardingRoutes, ...authRoutes],
);
