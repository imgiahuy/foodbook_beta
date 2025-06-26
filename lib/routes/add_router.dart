import 'package:foodbook_beta/features/home/presentation/post_pages.dart';
import 'package:go_router/go_router.dart';

final List<GoRoute> addRoutes = [
  GoRoute(path: '/add', name: 'add', builder: (context, state) => PostPages()),
];
