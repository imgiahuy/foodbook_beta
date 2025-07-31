import 'package:flutter/material.dart';
import 'package:foodbook_beta/features/posten/domain/model/post.dart';

typedef LikeToggleCallback = Future<void> Function(PostContent post);

class PostWidget extends StatelessWidget {
  final PostContent post;
  final LikeToggleCallback onLikeToggle;

  const PostWidget({
    Key? key,
    required this.post,
    required this.onLikeToggle,
  }) : super(key: key);

  void _showRecipeDialog(BuildContext context) {
    if (post.recipe == null || post.recipe!.isEmpty) return;

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
              SingleChildScrollView(child: Text(post.recipe ?? '')),
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
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: post.image != null
                  ? Image.network(
                      post.image!,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.broken_image,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
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

            Positioned(
              top: 10,
              left: 10,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: post.avatarUrl != null &&
                            post.avatarUrl!.isNotEmpty
                        ? NetworkImage(post.avatarUrl!)
                        : const AssetImage('assets/images/avatar-1.jpg')
                            as ImageProvider,
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

            Positioned(
              bottom: 15,
              left: 20,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => onLikeToggle(post),
                    child: Icon(
                      post.liked ? Icons.favorite : Icons.favorite_border,
                      size: 30,
                      color: post.liked ? Colors.red : Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "${post.likeCount}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 20),
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
