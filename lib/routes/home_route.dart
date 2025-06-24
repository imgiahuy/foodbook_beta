import 'package:foodbook_beta/features/home/presentation/home_pages.dart';
import 'package:go_router/go_router.dart';

final List<GoRoute> homeRoutes = [
  GoRoute(
    path: '/home',
    name: 'home',
    builder: (context, state) => HomePages(),
  ),
];
