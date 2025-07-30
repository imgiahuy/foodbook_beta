import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodbook_beta/features/posten/presentation/controller/post_controller.dart';
import 'package:foodbook_beta/shared/design_system/text_theme.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';

final postControllerProvider = ChangeNotifierProvider(
  (ref) => PostController(),
);

class PostEditor extends ConsumerStatefulWidget {
  const PostEditor({super.key});

  @override
  ConsumerState<PostEditor> createState() => _PostEditorState();
}

class _PostEditorState extends ConsumerState<PostEditor> {
  VideoPlayerController? _videoController;
  late TextEditingController _recipeController;

  @override
  void initState() {
    super.initState();
    final initialRecipe = ref.read(postControllerProvider).recipe ?? '';
    _recipeController = TextEditingController(text: initialRecipe);
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _recipeController.dispose();
    super.dispose();
  }

  void _initVideoController(File videoFile) async {
    _videoController?.dispose();
    _videoController = VideoPlayerController.file(videoFile);
    await _videoController!.initialize();
    _videoController!.setLooping(true);
    _videoController!.play();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(postControllerProvider);
    final notifier = ref.read(postControllerProvider);

    if (_recipeController.text != controller.recipe) {
      _recipeController.text = controller.recipe ?? '';
      _recipeController.selection = TextSelection.fromPosition(
        TextPosition(offset: _recipeController.text.length),
      );
    }

    if (controller.video != null) {
      if (_videoController == null ||
          _videoController!.dataSource != controller.video!.path) {
        _initVideoController(controller.video!);
      }
    } else {
      if (_videoController != null) {
        _videoController!.dispose();
        _videoController = null;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              notifier.clearDraft();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Pick Image or Video Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.image),
                  label: Text(
                    'Pick Image',
                    style: AppTextTheme.textTheme.labelMedium,
                  ),
                  onPressed: () => notifier.pickImage(),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.videocam),
                  label: const Text('Pick Video'),
                  onPressed: () => notifier.pickVideo(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Preview container
            Container(
              width: double.infinity,
              height: 600,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade200,
              ),
              child: controller.image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(controller.image!, fit: BoxFit.cover),
                    )
                  : (controller.video != null &&
                        _videoController != null &&
                        _videoController!.value.isInitialized)
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: AspectRatio(
                        aspectRatio: _videoController!.value.aspectRatio,
                        child: VideoPlayer(_videoController!),
                      ),
                    )
                  : const Center(child: Text('No media selected')),
            ),

            const SizedBox(height: 16),

            // Recipe input
            TextField(
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Write your recipe...',
                border: OutlineInputBorder(),
              ),
              controller: _recipeController,
              onChanged: (value) {
                notifier.setRecipe(value);
              },
            ),

            const SizedBox(
              height: 80,
            ), // Add bottom padding to avoid being hidden under button
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.send),
        label: const Text(
          'Post',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        onPressed: () async {
          await notifier.postContent();
          if (mounted) Navigator.pop(context);
        },
        extendedPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 14,
        ),
      ),
    );
  }
}
