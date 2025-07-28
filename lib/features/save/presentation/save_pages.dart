import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:foodbook_beta/shared/design_system/app_const.dart';
import 'package:foodbook_beta/shared/design_system/colors_digital.dart';
import 'package:foodbook_beta/features/save/logic/hive_servic_provider.dart';

class SavedPage extends ConsumerStatefulWidget {
  const SavedPage({super.key});

  @override
  ConsumerState<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends ConsumerState<SavedPage> {
  Map<String, String> savedRecipes = {};

  @override
  void initState() {
    super.initState();
    _loadSavedRecipes();
  }

  Future<void> _loadSavedRecipes() async {
    final hiveService = ref.read(hiveServiceProvider);
    final Map<String, String>? recipesMap = await hiveService.getAll<String>(
      'recipes',
    );
    setState(() {
      savedRecipes = recipesMap ?? {};
    });
  }

  Widget _buildSavedItem(String mediaPath, String rawData) {
    final file = File(mediaPath);
    final isVideo = mediaPath.toLowerCase().endsWith('.mp4');
    final recipe = rawData;

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
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.cornerRadius),
                  child: file.existsSync()
                      ? isVideo
                            ? _SavedVideoPlayer(videoFile: file)
                            : Image.file(file, fit: BoxFit.cover)
                      : Container(
                          color: Colors.grey[300],
                          alignment: Alignment.center,
                          child: Text(
                            'File not found',
                            style: TextStyle(color: black),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: AppSizes.spacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: AppSizes.buttonHeight,
                    width: AppSizes.buttonWidth,
                    child: ElevatedButton(
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
                                    const Text('Recipe'),
                                    const SizedBox(height: AppSizes.spacing),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: Text(recipe),
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
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      child: const Text('View'),
                    ),
                  ),
                  const SizedBox(width: AppSizes.largeSpacing),
                  SizedBox(
                    height: AppSizes.buttonHeight,
                    width: AppSizes.buttonWidth,
                    child: ElevatedButton(
                      onPressed: () async {
                        final hiveService = ref.read(hiveServiceProvider);
                        await hiveService.delete<String>('recipes', mediaPath);

                        if (!mounted) return;
                        setState(() {
                          savedRecipes.remove(mediaPath);
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Recipe deleted')),
                        );
                      },
                      child: const Text('Delete'),
                    ),
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
    if (savedRecipes.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Saved Recipes')),
        body: const Center(child: Text('No saved recipes found.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Recipes')),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSizes.spacing),
        itemCount: savedRecipes.length,
        itemBuilder: (context, index) {
          final mediaPath = savedRecipes.keys.elementAt(index);
          final rawData = savedRecipes[mediaPath]!;
          return _buildSavedItem(mediaPath, rawData);
        },
      ),
    );
  }
}

class _SavedVideoPlayer extends StatefulWidget {
  final File videoFile;
  const _SavedVideoPlayer({required this.videoFile});

  @override
  State<_SavedVideoPlayer> createState() => _SavedVideoPlayerState();
}

class _SavedVideoPlayerState extends State<_SavedVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(true);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
  }
}
