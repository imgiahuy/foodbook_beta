import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VideosProvider extends StateNotifier<File?> {
  VideosProvider() : super(null);

  void setVideo(File file) {
    state = file;
  }

  void clearVideo() {
    state = null;
  }
}

final videosProvider = StateNotifierProvider<VideosProvider, File?>(
  (ref) => VideosProvider(),
);
