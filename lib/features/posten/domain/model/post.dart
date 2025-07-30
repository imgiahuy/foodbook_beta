class PostContent {
  final String? username;
  final String? postid;
  final String? image;
  final String? video;
  final String? recipe;
  bool liked;

  PostContent({
    this.username,
    this.postid,
    this.image,
    this.video,
    this.recipe,
    this.liked = false,
  });
}
