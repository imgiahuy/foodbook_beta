import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodbook_beta/features/posten/presentation/state/post_controller_provider.dart';
import 'package:foodbook_beta/shared/common_widgets/bottom_nav_bar.dart';
import 'post_widget.dart';

class SurfenPage extends ConsumerWidget {
  const SurfenPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postController = ref.watch(postControllerProvider);

    if (postController.posts.isEmpty) {
      Future.microtask(() => ref.read(postControllerProvider).loadPosts());
    }

    return Scaffold(
      body: postController.posts.isEmpty
          ? const Center(child: Text('No posts yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: postController.posts.length,
              itemBuilder: (context, index) {
                final post = postController.posts[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: PostWidget(post: post, onLikeToggle: (post) async {
                    await postController.toggleLike(post);
                  },),
                );
              },
            ),
      bottomNavigationBar: BottomNavBar(currentIndex: 1),
    );
  }
}
