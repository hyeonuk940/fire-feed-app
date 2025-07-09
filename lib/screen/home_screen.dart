import 'package:flutter/material.dart';
import '../models/feed.dart';
import '../widgets/feed_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fire Feed'),        //상단 타이틀
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('feeds')
            .orderBy('createdAt', descending: true)    //피드 최신순 정렬
            .snapshots(),                //실시간 스트림 데이터 제공
        builder: (context, snapshot){     //스트림 변경시 호출되어 업데이트
          if (snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError){
            return Center(child: Text('Error:${snapshot.error}'));
          }
          if(!snapshot.hasData || snapshot.data !.docs.isEmpty){
            return const Center(child: Text('No feeds available.'));
          }

          final feeds = snapshot.data!.docs
              .map((doc) => Feed.fromFirestore(doc))//Firestore에서 받은 DocumentSnapshot 리스트를 Dart 객체로 변환
              .toList();

          return ListView.builder(          //피드 수 만큼 렌더링
            itemCount: feeds.length,
            itemBuilder: (context,index){
              final feed = feeds[index];

              return FeedCard(feed: feed);    //각 피드 항목
            },
          );
        }
      )
    );
  }
}
