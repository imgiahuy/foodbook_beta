import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodbook_beta/features/home/logic/post_content_provider.dart';
import 'package:video_player/video_player.dart';

class HomePages extends ConsumerStatefulWidget {
  const HomePages({super.key});

  @override
  ConsumerState<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends ConsumerState<HomePages> {
  VideoPlayerController? _videoController;

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final post = ref.watch(postContentProvider);
    if (post?.video != null) {
      _videoController = VideoPlayerController.file(post!.video!)
        ..initialize().then((_) {
          _videoController?.setLooping(true);
          _videoController?.play();
          setState(() {});
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final post = ref.watch(postContentProvider);

    Widget content;
    if (post == null) {
      content = const Center(child: Text("No content posted."));
    } else if (post.image != null) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.file(post.image!, fit: BoxFit.cover),
      );
    } else if (post.video != null &&
        _videoController?.value.isInitialized == true) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          aspectRatio: _videoController!.value.aspectRatio,
          child: VideoPlayer(_videoController!),
        ),
      );
    } else {
      content = const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 500,
              // no minWidth set here
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [AspectRatio(aspectRatio: 1, child: content)],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
