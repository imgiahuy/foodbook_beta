import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodbook_beta/features/posten/domain/model/post.dart';
import 'package:foodbook_beta/features/posten/presentation/state/post_controller_provider.dart';
import 'package:foodbook_beta/features/posten/presentation/widgets/post_editor_page.dart';
import 'package:foodbook_beta/shared/common_widgets/bottom_nav_bar.dart';
import 'post_widget.dart';

class SwipePage extends ConsumerStatefulWidget {
  @override
  _SwipePageState createState() => _SwipePageState();
}

class _SwipePageState extends ConsumerState<SwipePage> {
  // Track dismissed posts locally by their postid
  final Set<String> dismissedPostIds = {};

  @override
  Widget build(BuildContext context) {
    final postController = ref.watch(postControllerProvider);
    final posts = postController.posts;

    // Filter out posts dismissed locally
    final visiblePosts = posts
        .where((p) => !dismissedPostIds.contains(p.postid))
        .toList();

    return Scaffold(
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
      appBar: AppBar(title: Text("Swipe Cards Demo")),
      body: Center(
        child: Stack(
          children: visiblePosts.asMap().entries.map((entry) {
            int index = entry.key;
            PostContent post = entry.value;

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
                child: Icon(Icons.thumb_down, color: Colors.white),
              ),
              secondaryBackground: Container(
                color: Colors.green,
                alignment: Alignment.centerRight,
                child: Icon(Icons.thumb_up, color: Colors.white),
              ),
              child: PostWidget(post: post),
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => PostEditor()),
          );
          setState(() {
            dismissedPostIds
                .clear();
          });
        },
      ),
    );
  }
}
