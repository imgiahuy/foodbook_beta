import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodbook_beta/core/theme/app_theme/app_const.dart';
import 'package:foodbook_beta/core/theme/colors/colors_digital.dart';
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

    // Debug print to check if files exist
    for (var path in savedRecipes.keys) {
      final exists = File(path).existsSync();
      print('Saved image path: $path, exists: $exists');
    }
  }

  Widget _buildSavedItem(String imagePath, String recipe) {
    final file = File(imagePath);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Container(
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(AppSizes.cornerRadius),
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
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: file.existsSync()
                    ? Image.file(file, fit: BoxFit.cover)
                    : Container(
                        color: Colors.grey[300],
                        height: 200,
                        alignment: Alignment.center,
                        child: Text(
                          'Image not found',
                          style: TextStyle(color: black),
                        ),
                      ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: SizedBox(
                              width: 400,
                              height: 600,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text('Recipe'),
                                    const SizedBox(height: 16),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: Text(recipe),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
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
                  SizedBox(
                    height: AppSizes.buttonHeight,
                    width: AppSizes.buttonWidth,
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          final hiveService = ref.read(hiveServiceProvider);
                          await hiveService.delete<String>(
                            'recipes',
                            imagePath,
                          );

                          if (!mounted) {
                            return; // Ensure widget is still active before updating UI
                          }

                          setState(() {
                            savedRecipes.remove(imagePath);
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Recipe deleted')),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to delete recipe: $e'),
                            ),
                          );
                        }
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
        padding: const EdgeInsets.all(12),
        itemCount: savedRecipes.length,
        itemBuilder: (context, index) {
          final imagePath = savedRecipes.keys.elementAt(index);
          final recipe = savedRecipes[imagePath]!;
          return _buildSavedItem(imagePath, recipe);
        },
      ),
    );
  }
}
