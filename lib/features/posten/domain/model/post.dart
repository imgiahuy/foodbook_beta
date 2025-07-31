class PostContent {
  final String? username;
  final String? postid;
  final String? image;
  final String? recipe;
  final String? avatarUrl;
  bool liked;

  PostContent({
    this.username,
    this.postid,
    this.image,
    this.recipe,
    this.avatarUrl,
    this.liked = false,
  });
}
