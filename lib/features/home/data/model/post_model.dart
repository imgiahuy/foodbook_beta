import 'dart:io';

class PostContent {
  final File? image;
  final File? video;
  final String? recipe;
  bool liked; // <-- NEW FIELD

  PostContent({this.image, this.video, this.recipe, this.liked = false});
}
