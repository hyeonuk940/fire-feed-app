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
        title: const Text('Fire Feed'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('feeds')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot){
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
              .map((doc) => Feed.fromFirestore(doc))
              .toList();

          return ListView.builder(
            itemCount: feeds.length,
            itemBuilder: (context,index){
              final feed = feeds[index];

              return FeedCard(feed: feed);
            },
          );
        }
      )
    );
  }
}
