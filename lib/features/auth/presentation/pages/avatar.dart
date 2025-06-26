import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodbook_beta/core/theme/colors/colors_digital.dart';
import 'package:foodbook_beta/features/auth/logic/avatar_provider.dart';

class Avatar extends ConsumerWidget {
  final VoidCallback onTap;

  const Avatar({required this.onTap, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatarFile = ref.watch(avatarFileProvider);

    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 50,
        backgroundImage: avatarFile != null
            ? FileImage(avatarFile) // local image
            : const AssetImage('assets/images/default_avatar.png')
                  as ImageProvider,
        child: avatarFile == null
            ? Icon(Icons.camera_alt, size: 30, color: white)
            : null,
      ),
    );
  }
}
