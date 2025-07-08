class Feed {
  final String title;
  final String content;
  final String imageUrl;

  Feed({
    required this.title,
    required this.content,
    required this.imageUrl,
  });

  factory Feed.fromJson(Map<String, dynamic> json) {
    return Feed(
      title: json['title'],
      content: json['content'],
      imageUrl: json['imageUrl'],
    );
  }
}
