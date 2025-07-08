import 'package:cloud_firestore/cloud_firestore.dart';

class Feed {
  final String title;
  final String content;
  final String imageUrl;
  final Timestamp createdAt;

  Feed({
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.createdAt,
  });

  factory Feed.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Feed(title: data['title'] ?? '', content: data['content'] ?? '', imageUrl: data['imageUrl'],
    createdAt: data['createdAt'] ?? Timestamp.now(),);
  }
}
