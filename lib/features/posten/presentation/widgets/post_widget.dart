import 'dart:io';
import 'package:flutter/material.dart';
import 'package:foodbook_beta/features/posten/domain/model/post.dart';
import 'package:video_player/video_player.dart';

class PostWidget extends StatefulWidget {
  final PostContent post;

  const PostWidget({Key? key, required this.post}) : super(key: key);

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  VideoPlayerController? _videoController;
  String? _currentVideoPath;

  late bool _isLiked;
  int _likeCount = 0;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.post.liked;
    if (widget.post.video != null) {
      _initializeVideo(File(widget.post.video!));
    }
  }

  Future<void> _initializeVideo(File videoFile) async {
    // If same video is already loaded, don't re-initialize
    if (_currentVideoPath == videoFile.path && _videoController != null) return;

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
      debugPrint('Video initialization failed: $e');
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
      widget.post.liked = _isLiked; // Update PostContent liked status
    });
  }

  void _showRecipeDialog(BuildContext context) {
    if (widget.post.recipe == null || widget.post.recipe!.isEmpty) return;

    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(16),
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Recipe',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(child: Text(widget.post.recipe ?? '')),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 700),
      child: Container(
        height: 600,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.transparent,
        ),
        child: Stack(
          children: [
            // Media: Image or Video
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: post.image != null
                  ? Image.file(
                      File(post.image!),
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : post.video != null &&
                        _videoController != null &&
                        _videoController!.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _videoController!.value.aspectRatio,
                      child: VideoPlayer(_videoController!),
                    )
                  : Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),
            ),

            // Top User Info
            Positioned(
              top: 10,
              left: 10,
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage('assets/images/avatar-1.jpg'),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    post.username ?? "User",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(1, 1),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Actions (like & recipe)
            Positioned(
              bottom: 15,
              left: 20,
              child: Row(
                children: [
                  // Like Button
                  GestureDetector(
                    onTap: _toggleLike,
                    child: Icon(
                      _isLiked ? Icons.favorite : Icons.favorite_border,
                      size: 30,
                      color: _isLiked ? Colors.orange : Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "$_likeCount",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(width: 20),

                  // Recipe Button
                  GestureDetector(
                    onTap: () => _showRecipeDialog(context),
                    child: const Icon(
                      Icons.comment,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
