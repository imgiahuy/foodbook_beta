import 'package:foodbook_beta/features/auth/presentation/login_pages.dart';
import 'package:foodbook_beta/features/auth/presentation/register_pages.dart';
import 'package:go_router/go_router.dart';

final List<GoRoute> authRoutes = [
  GoRoute(
    path: 'welcome/signin',
    name: 'signin',
    builder: (context, state) => LoginPages(),
  ),
  GoRoute(
    path: 'welcome/signup',
    name: 'signup',
    builder: (context, state) => RegisterPages(),
  ),
];
