import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodbook_beta/features/home/data/model/post_model.dart';
import 'package:foodbook_beta/features/home/logic/hive_service_provider.dart';
import 'package:foodbook_beta/features/home/logic/post_content_provider.dart';
import 'package:swipe_cards/swipe_cards.dart';

class SwipePage extends ConsumerStatefulWidget {
  const SwipePage({super.key});

  @override
  ConsumerState<SwipePage> createState() => _SwipePageState();
}

class _SwipePageState extends ConsumerState<SwipePage> {
  late MatchEngine _matchEngine;
  List<SwipeItem> _swipeItems = [];

  void _buildSwipeItems(List<PostContent> posts) {
    _swipeItems = posts.asMap().entries.map((entry) {
      final index = entry.key;
      final post = entry.value;
      return SwipeItem(
        content: post,
        likeAction: () async {
          if (post.recipe != null && post.image != null) {
            final hiveService = ref.read(hiveServiceProvider);
            final path = post.image!.path;
            await hiveService.set<String>('recipes', path, post.recipe!);
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Recipe saved locally!')),
            );
          }
          ref.read(postContentProvider.notifier).removeAt(index);
          _refreshSwipeItems();
        },
        nopeAction: () {
          ref.read(postContentProvider.notifier).removeAt(index);
          _refreshSwipeItems();
        },
      );
    }).toList();
  }

  void _refreshSwipeItems() {
    final updatedPosts = ref.read(postContentProvider);
    setState(() {
      _buildSwipeItems(updatedPosts);
      _matchEngine = MatchEngine(swipeItems: _swipeItems);
    });
  }

  @override
  void initState() {
    super.initState();
    final posts = ref.read(postContentProvider);
    _buildSwipeItems(posts);
    _matchEngine = MatchEngine(swipeItems: _swipeItems);
  }

  @override
  Widget build(BuildContext context) {
    if (_swipeItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Discover Recipes')),
        body: const Center(child: Text('No posts available')),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: const Text('Discover Recipes')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: SwipeCards(
            matchEngine: _matchEngine,
            itemBuilder: (BuildContext context, int index) {
              final post = _swipeItems[index].content as PostContent;

              return Center(
                child: SizedBox(
                  width: screenWidth * 0.85,
                  height: screenHeight * 0.65,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (post.image != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(
                              post.image!,
                              fit: BoxFit.cover,
                              height: screenHeight * 0.4,
                              width: double.infinity,
                            ),
                          )
                        else if (post.video != null)
                          const Icon(Icons.videocam, size: 100),
                        const SizedBox(height: 16),
                        // Recipe text removed from card as requested
                      ],
                    ),
                  ),
                ),
              );
            },
            onStackFinished: () {
              ref.read(postContentProvider.notifier).clearAll();
              setState(() {
                _buildSwipeItems([]);
                _matchEngine = MatchEngine(swipeItems: _swipeItems);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'You have swiped through all recipes! All posts cleared.',
                  ),
                ),
              );
            },
            upSwipeAllowed: false,
            fillSpace: true,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/addPost');
        },
      ),
    );
  }
}
