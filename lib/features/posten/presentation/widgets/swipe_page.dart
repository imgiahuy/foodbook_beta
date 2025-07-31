import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodbook_beta/features/posten/presentation/state/post_controller_provider.dart';
import 'package:foodbook_beta/features/posten/presentation/widgets/post_editor_page.dart';
import 'package:foodbook_beta/shared/common_widgets/bottom_nav_bar.dart';
import 'post_widget.dart';

class SwipePage extends ConsumerStatefulWidget {
  const SwipePage({Key? key}) : super(key: key);

  @override
  _SwipePageState createState() => _SwipePageState();
}

class _SwipePageState extends ConsumerState<SwipePage> {
  final Set<String> dismissedPostIds = {};

  @override
  Widget build(BuildContext context) {
    final postController = ref.watch(postControllerProvider);
    final posts = postController.posts;

    // Filter out posts dismissed locally
    final visiblePosts = posts.where((p) => !dismissedPostIds.contains(p.postid)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Foodbook")),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      body: Center(
        child: Stack(
          children: visiblePosts.asMap().entries.map((entry) {
            final index = entry.key;
            final post = entry.value;

            return Dismissible(
              key: Key(post.postid!),
              direction: DismissDirection.horizontal,
              onDismissed: (direction) {
                setState(() {
                  dismissedPostIds.add(post.postid!);
                });
                if (direction == DismissDirection.endToStart) {
                  print("Swiped left on post $index");
                } else if (direction == DismissDirection.startToEnd) {
                  print("Swiped right on post $index");
                }
              },
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20),
                child: const Icon(Icons.thumb_down, color: Colors.white),
              ),
              secondaryBackground: Container(
                color: Colors.green,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: const Icon(Icons.thumb_up, color: Colors.white),
              ),
              child: PostWidget(
                post: post,
                onLikeToggle: (post) async {
                  await ref.read(postControllerProvider.notifier).toggleLike(post);
                },
              ),
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PostEditor()),
          );
          setState(() {
            dismissedPostIds.clear();
          });
        },
      ),
    );
  }
}
