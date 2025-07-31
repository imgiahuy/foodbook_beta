import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodbook_beta/features/posten/presentation/state/post_controller_provider.dart';

class PostEditor extends ConsumerStatefulWidget {
  const PostEditor({super.key});

  @override
  ConsumerState<PostEditor> createState() => _PostEditorState();
}

class _PostEditorState extends ConsumerState<PostEditor> {
  late TextEditingController _recipeController;

  @override
  void initState() {
    super.initState();
    final initialRecipe = ref.read(postControllerProvider).recipe ?? '';
    _recipeController = TextEditingController(text: initialRecipe);
  }

  @override
  void dispose() {
    _recipeController.dispose();
    super.dispose();
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
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => notifier.pickImage(),
              child: Container(
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
                    : const Center(child: Text('No media selected')),
              ),
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

            const SizedBox(height: 80),
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
          final controller = ref.read(postControllerProvider);
          if (controller.image == null ||
              (controller.recipe.trim().isEmpty)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Please add an image and write a recipe before posting.',
                ),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }
          await controller.postContent();
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
