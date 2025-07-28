import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImagesProvider extends StateNotifier<File?> {
  ImagesProvider() : super(null);

  void setImage(File file) {
    state = file;
  }

  void clearImage() {
    state = null;
  }
}

final imagesProvider = StateNotifierProvider<ImagesProvider, File?>(
  (ref) => ImagesProvider(),
);
