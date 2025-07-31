import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodbook_beta/features/auth/presentation/states/auth_provider.dart';
import 'package:foodbook_beta/features/posten/data/repositories/post_impl.dart';
import 'package:foodbook_beta/features/posten/domain/model/post_repository.dart';
import 'package:foodbook_beta/features/posten/presentation/controller/post_controller.dart';

final postRepositoryProvider = Provider<PostRepository>(
  (ref) => PostRepositoryImpl(),
);

final postControllerProvider = ChangeNotifierProvider<PostController>(
  (ref) {
    final authRepo = ref.watch(authRepositoryProvider);
    final repository = ref.read(postRepositoryProvider);
    return PostController(repository, authRepo);
  },
);
