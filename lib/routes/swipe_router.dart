import 'package:foodbook_beta/features/swipe/presentation/swipe_pages.dart';
import 'package:go_router/go_router.dart';

final List<GoRoute> swipeRoutes = [
  GoRoute(
    path: '/swipe',
    name: 'swipe',
    builder: (context, state) => SwipePage(),
  ),
];
