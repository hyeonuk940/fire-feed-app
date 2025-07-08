import 'package:flutter/material.dart';
import 'package:fire_feed_app/screen/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> feedItems = [
      {
        'title': '감정 일기 작성 팁',
        'subtitle': '하루의 감정을 기록하는 3가지 방법을 소개합니다.',
      },
      {
        'title': '동료 소방관의 이야기',
        'subtitle': '극한 상황에서 회복력을 키운 경험담입니다.',
      },
      {
        'title': '불면증 극복 훈련법',
        'subtitle': '잠 못 드는 밤, 시도해볼 수 있는 호흡 훈련!',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fire Feed'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: feedItems.length,
              itemBuilder: (context, index) {
                final item = feedItems[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(item['title']!),
                    subtitle: Text(item['subtitle']!),
                    leading: const Icon(Icons.local_fire_department, color: Colors.red),
                    onTap: () {
                      // 추후 상세 페이지 연결 가능
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
