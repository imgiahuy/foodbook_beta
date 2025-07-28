import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import 'package:foodbook_beta/shared/design_system/app_const.dart';
import 'package:foodbook_beta/shared/design_system/text_theme.dart';
import 'package:foodbook_beta/shared/design_system/colors_digital.dart';
import 'package:foodbook_beta/features/posten/data/model/post_model.dart';
import 'package:foodbook_beta/features/posten/logic/hive_service_provider.dart';
import 'package:foodbook_beta/features/posten/logic/post_content_provider.dart';

class HomePages extends ConsumerStatefulWidget {
  const HomePages({super.key});

  @override
  ConsumerState<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends ConsumerState<HomePages> {
  final Map<int, VideoPlayerController> _videoControllers = {};

  @override
  void initState() {
    super.initState();

    // Global error handling (optional but helpful)
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.dumpErrorToConsole(details);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      debugPrint('Platform Error: $error\n$stack');
      return true;
    };
  }

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
        if (videoFile.existsSync()) {
          final controller = VideoPlayerController.file(videoFile);
          controller
              .initialize()
              .then((_) {
                controller.setLooping(true);
                controller.play();
                if (mounted) {
                  setState(() {});
                }
              })
              .catchError((e) {
                debugPrint("Video init error: $e");
              });
          _videoControllers[index] = controller;
        } else {
          debugPrint('Video file not found: ${videoFile.path}');
        }
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

    bool liked = post.liked;
    int likeCount = liked ? 1 : 0;

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
                color: Colors.black.withOpacity(0.1),
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
                              liked ? Icons.favorite : Icons.favorite_border,
                              color: liked ? orange : null,
                            ),
                            onPressed: () {
                              setLikeState(() {
                                liked = !liked;
                                post.liked = liked;
                                likeCount = liked ? 1 : 0;
                              });
                            },
                          ),
                          Text('$likeCount'),
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
                                                post.video?.path ??
                                                'unknown';
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
    final posts = ref.watch(postContentProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('FOODBOOK', style: TextStyle(color: orange)),
      ),
      body: posts.isEmpty
          ? const Center(child: Text('No posts yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(AppSizes.spacing),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return _buildPost(post, index);
              },
            ),
    );
  }
}
