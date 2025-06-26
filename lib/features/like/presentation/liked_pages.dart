import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodbook_beta/core/theme/app_theme/app_const.dart';
import 'package:foodbook_beta/core/theme/app_theme/text_theme.dart';
import 'package:foodbook_beta/core/theme/colors/colors_digital.dart';
import 'package:foodbook_beta/features/home/data/model/post_model.dart';
import 'package:foodbook_beta/features/home/logic/hive_service_provider.dart';
import 'package:foodbook_beta/features/like/logic/liked_post_provider.dart';
import 'package:video_player/video_player.dart';

class LikedPage extends ConsumerStatefulWidget {
  const LikedPage({super.key});

  @override
  ConsumerState<LikedPage> createState() => _LikedPageState();
}

class _LikedPageState extends ConsumerState<LikedPage> {
  final Map<int, VideoPlayerController> _videoControllers = {};

  @override
  void dispose() {
    for (var controller in _videoControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildPost(PostContent post, int index) {
    Widget content;

    if (post.image != null) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.cornerRadius),
        child: Image.file(post.image!, fit: BoxFit.cover),
      );
    } else if (post.video != null) {
      final videoFile = post.video!;
      if (!_videoControllers.containsKey(index)) {
        final controller = VideoPlayerController.file(videoFile);
        controller.initialize().then((_) {
          controller.setLooping(true);
          controller.play();
          setState(() {});
        });
        _videoControllers[index] = controller;
      }
      final controller = _videoControllers[index];
      if (controller != null && controller.value.isInitialized) {
        content = ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.cornerRadius),
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          ),
        );
      } else {
        content = const Center(child: CircularProgressIndicator());
      }
    } else {
      content = const SizedBox();
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Container(
          margin: const EdgeInsets.only(bottom: AppSizes.smallPadding),
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(AppSizes.cornerRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(25),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(AppSizes.spacing),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(aspectRatio: 1, child: content),
              const SizedBox(height: AppSizes.spacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StatefulBuilder(
                    builder: (context, setLikeState) {
                      return Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              post.liked
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: post.liked ? orange : null,
                            ),
                            onPressed: () {
                              setLikeState(() {
                                setState(() {
                                  post.liked = !post.liked;
                                });
                              });
                            },
                          ),
                          Text(post.liked ? '1' : '0'),
                        ],
                      );
                    },
                  ),
                  const SizedBox(width: AppSizes.largeSpacing),
                  if (post.recipe != null && post.recipe!.isNotEmpty)
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (dialogContext) => Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppSizes.cornerRadius,
                              ),
                            ),
                            child: SizedBox(
                              width: 400,
                              height: 600,
                              child: Padding(
                                padding: const EdgeInsets.all(AppSizes.spacing),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Recipe',
                                      style: AppTextTheme.textTheme.labelMedium,
                                    ),
                                    const SizedBox(height: AppSizes.spacing),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: Text(post.recipe!),
                                      ),
                                    ),
                                    const SizedBox(height: AppSizes.spacing),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(dialogContext).pop(),
                                          child: const Text('Close'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            final hiveService = ref.read(
                                              hiveServiceProvider,
                                            );
                                            final path =
                                                post.image?.path ??
                                                post.video!.path;
                                            await hiveService.set<String>(
                                              'recipes',
                                              path,
                                              post.recipe!,
                                            );
                                            Navigator.of(dialogContext).pop();
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Recipe saved locally!',
                                                ),
                                              ),
                                            );
                                          },
                                          child: const Text('Save'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      child: const Text('Recipe'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final likedPosts = ref.watch(likedPostsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Liked Posts')),
      body: likedPosts.isEmpty
          ? const Center(child: Text('No liked posts yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(AppSizes.spacing),
              itemCount: likedPosts.length,
              itemBuilder: (context, index) {
                final post = likedPosts[index];
                return _buildPost(post, index);
              },
            ),
    );
  }
}
