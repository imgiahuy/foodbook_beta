import 'package:foodbook_beta/routes/auth_router.dart';
import 'package:foodbook_beta/routes/home_route.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(routes: [...authRouter, ...homeRoutes]);
