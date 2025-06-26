import 'package:foodbook_beta/routes/auth_router.dart';
import 'package:foodbook_beta/routes/shell_router.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(routes: [...authRouter, ...shellRoutes]);
