import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodbook_beta/core/theme/app_theme/app_const.dart';
import 'package:foodbook_beta/core/theme/colors/colors_digital.dart';
import 'package:foodbook_beta/features/home/logic/images_provider.dart';
import 'package:foodbook_beta/features/home/logic/video_provider.dart';
import 'package:foodbook_beta/features/home/logic/post_content_provider.dart';
import 'package:foodbook_beta/features/home/presentation/home_pages.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class PostPages extends ConsumerStatefulWidget {
  const PostPages({super.key});

  @override
  ConsumerState<PostPages> createState() => _PostPagesState();
}

class _PostPagesState extends ConsumerState<PostPages> {
  VideoPlayerController? _videoController;
  String? _currentVideoPath;

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _initializeVideo(File videoFile) async {
    debugPrint("Initializing video: ${videoFile.path}");

    // Dispose previous controller if exists
    await _videoController?.dispose();
    _videoController = VideoPlayerController.file(videoFile);

    try {
      await _videoController!.initialize();
      _videoController!.setLooping(true);
      setState(() {
        _currentVideoPath = videoFile.path;
        _videoController!.play();
      });
    } catch (e) {
      debugPrint('Error initializing video player: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageFile = ref.watch(imagesProvider);
    final videoFile = ref.watch(videosProvider);

    // Initialize video if it's new
    if (videoFile != null && videoFile.path != _currentVideoPath) {
      _initializeVideo(videoFile);
    }

    Widget displayContent;
    if (videoFile != null && _videoController?.value.isInitialized == true) {
      displayContent = ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.cornerRadius),
        child: FittedBox(
          fit: BoxFit.cover,
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            width: _videoController!.value.size.width,
            height: _videoController!.value.size.height,
            child: VideoPlayer(_videoController!),
          ),
        ),
      );
    } else if (imageFile != null) {
      displayContent = ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.cornerRadius),
        child: Image.file(imageFile, fit: BoxFit.cover),
      );
    } else {
      displayContent = const Icon(
        Icons.camera_alt,
        size: 50,
        color: Colors.white,
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            final image = ref.read(imagesProvider);
            final video = ref.read(videosProvider);

            if (image != null) {
              ref.read(postContentProvider.notifier).setImage(image);
            } else if (video != null) {
              ref.read(postContentProvider.notifier).setVideo(video);
            }

            ref.read(imagesProvider.notifier).clearImage();
            ref.read(videosProvider.notifier).clearVideo();

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Post successful!')));

            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomePages()),
              );
            });
          },
          icon: const Icon(Icons.done),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Clear selected image and video
              ref.read(imagesProvider.notifier).clearImage();
              ref.read(videosProvider.notifier).clearVideo();

              // Dispose video controller if any
              _videoController?.dispose();
              _videoController = null;
              _currentVideoPath = null;

              // Update UI
              setState(() {});

              // Optional: show snackbar to confirm reset
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Post reset')));
            },
            icon: const Icon(Icons.cancel_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 6,
            child: Container(
              decoration: BoxDecoration(color: yellow),
              width: double.infinity,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.mediumPadding,
                    AppSizes.smallSpacing,
                    AppSizes.mediumPadding,
                    20,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        AppSizes.cornerRadius,
                      ),
                      color: yellow,
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Center(child: displayContent),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: AppSizes.buttonHeight,
                    width: AppSizes.buttonWidthLarge,
                    child: ElevatedButton(
                      onPressed: () async {
                        final picker = ImagePicker();
                        final pickedFile = await picker.pickImage(
                          source: ImageSource.gallery,
                        );
                        if (pickedFile != null) {
                          final file = File(pickedFile.path);
                          ref.read(imagesProvider.notifier).setImage(file);
                          ref.read(videosProvider.notifier).clearVideo();
                          await _videoController?.dispose();
                          _videoController = null;
                          _currentVideoPath = null;
                          setState(() {});
                        }
                      },
                      child: const Text('Post Image'),
                    ),
                  ),
                  SizedBox(
                    height: AppSizes.buttonHeight,
                    width: AppSizes.buttonWidthLarge,
                    child: ElevatedButton(
                      onPressed: () async {
                        final picker = ImagePicker();
                        final pickedVideo = await picker.pickVideo(
                          source: ImageSource.gallery,
                          maxDuration: const Duration(seconds: 30),
                        );
                        if (pickedVideo != null) {
                          final file = File(pickedVideo.path);
                          ref.read(videosProvider.notifier).setVideo(file);
                          ref.read(imagesProvider.notifier).clearImage();
                          // Initialization handled in build
                        }
                      },
                      child: const Text('Post Video'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
