import 'package:foodbook_beta/features/like/presentation/liked_pages.dart';
import 'package:go_router/go_router.dart';

final List<GoRoute> likeRoutes = [
  GoRoute(
    path: '/like',
    name: 'like',
    builder: (context, state) => LikedPage(),
  ),
];
