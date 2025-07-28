import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AvatarNotifier extends StateNotifier<File?> {
  AvatarNotifier() : super(null);

  void setAvatar(File file) {
    state = file;
  }

  void clearAvatar() {
    state = null;
  }
}

final avatarFileProvider = StateNotifierProvider<AvatarNotifier, File?>(
  (ref) => AvatarNotifier(),
);
