import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodbook_beta/features/posten/domain/model/post.dart';
import 'package:foodbook_beta/features/posten/presentation/state/post_controller_provider.dart';
import 'package:foodbook_beta/shared/common_widgets/bottom_nav_bar.dart';

class BookPage extends ConsumerStatefulWidget {
  const BookPage({Key? key}) : super(key: key);

  @override
  ConsumerState<BookPage> createState() => _BookPageState();
}

class _BookPageState extends ConsumerState<BookPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? currentUsername;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);

    Future.microtask(() async {
      final username = await ref.read(postControllerProvider).getCurrentUsername();
      setState(() {
        currentUsername = username;
      });

      await ref.read(postControllerProvider).loadPosts();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postController = ref.watch(postControllerProvider);
    final posts = postController.posts;

    // Warten bis username geladen
    if (currentUsername == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Nur eigene Posts filtern
    final yourPosts = posts.where((post) => post.username == currentUsername).toList();

    Widget buildGrid(List<PostContent> posts) {
      if (posts.isEmpty) {
        return const Center(child: Text("No posts found"));
      }
      return GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          childAspectRatio: 1,
        ),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: post.image != null
                ? Image.network(
                    post.image!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  )
                : Container(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported, color: Colors.grey),
                  ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Book'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Your Posts'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildGrid(yourPosts),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 3),
    );
  }
}
