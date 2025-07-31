class PostContent {
  final String? username;
  final String? postid;
  final String? image;
  final String? recipe;
  final String? avatarUrl;
  final int likeCount;
  final bool liked;

  PostContent({
    this.username,
    this.postid,
    this.image,
    this.recipe,
    this.avatarUrl,
    this.liked = false,
    this.likeCount = 0,
  });

  PostContent copyWith({
    String? username,
    String? postid,
    String? image,
    String? recipe,
    String? avatarUrl,
    bool? liked,
    int? likeCount,
  }) {
    return PostContent(
      username: username ?? this.username,
      postid: postid ?? this.postid,
      image: image ?? this.image,
      recipe: recipe ?? this.recipe,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      liked: liked ?? this.liked,
      likeCount: likeCount ?? this.likeCount,
    );
  }
}
