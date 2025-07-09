import 'package:cloud_firestore/cloud_firestore.dart';

class Feed {                                       //제목, 이미지, 텍스트, 시간 구성
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

  factory Feed.fromFirestore(DocumentSnapshot doc) {   //Firestore 문서로 부터 Feed 클래스 생성
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Feed(title: data['title'] ?? '', content: data['content'] ?? '', imageUrl: data['imageUrl'],
    createdAt: data['createdAt'] ?? Timestamp.now(),);
  }
}