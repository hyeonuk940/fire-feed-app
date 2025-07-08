import 'package:flutter/material.dart';
import '../models/feed.dart';

class FeedCard extends StatelessWidget {
  final Feed feed;

  const FeedCard({required this.feed, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              feed.title,
              style: Theme
                  .of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.network(
                feed.imageUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context,child,progress){
                  return progress == null ? child : Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace){
                  return Icon(Icons.error, size:40);
                },
              ),
            ),
            const SizedBox(height: 12),
            Text(
              feed.content,
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}