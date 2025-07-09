# 🧯 FireFeed: Flutter + Firebase 기반 앱 개발 튜토리얼

본 문서는 FireFeed 앱을 처음부터 구성하고 Firebase 연동까지 구현하는 전체 과정을 설명함.

---

## 🔹 1. 프로젝트 초기 세팅

### ✅ Flutter 프로젝트 생성

1. Android Studio 실행 → `New Flutter Project` 선택
2. Project name 입력 (예: fire_feed_app)
3. Platforms에서 Android만 체크 → Create
4. 경로 선택 후 Finish

```bash
flutter doctor -v  # Flutter 환경 점검
```

※ iOS는 지원하지 않으므로 CocoaPods 설치는 생략함.

---

###  🔥 Flutter CLI를 이용한 Firebase 연동 튜토리얼

Flutter + Firebase 설정은 다음 링크 참조

https://github.com/Hoeng317/fire_feed_server?tab=readme-ov-file#-flutter-cli%EB%A5%BC-%EC%9D%B4%EC%9A%A9%ED%95%9C-firebase-%EC%97%B0%EB%8F%99-%ED%8A%9C%ED%86%A0%EB%A6%AC%EC%96%BC

---


### ✅ 기본 폴더 구조 생성

아래와 같은 폴더를 수동으로 생성함:

```bash
/lib
  ├── screens
  ├── widgets
  ├── models
  ├── main.dart
```

---

### ✅ 첫 화면 구성: HomeScreen

`lib/screens/home_screen.dart` 생성:

```dart
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FireFeed')),
      body: const Center(
        child: Text('Hello Firefighter'),
      ),
    );
  }
}
```

`main.dart`에서 홈화면을 연결함:

```dart
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MaterialApp(
    home: HomeScreen(),
  ));
}
```

---

## 🔹 2. Firebase 연동

### ✅ Firebase 프로젝트 생성

1. [Firebase Console](https://console.firebase.google.com) → 새 프로젝트 생성
2. Android 앱 등록 (패키지명: `com.example.fire_feed_app`)
3. `google-services.json` 다운로드 → `android/app` 폴더에 넣음

### ✅ Firebase CLI 및 FlutterFire CLI 설치

```bash
npm install -g firebase-tools
firebase login
flutter pub global activate flutterfire_cli
export PATH="$PATH":"$HOME/.pub-cache/bin"
flutterfire configure
```

### ✅ firebase_core 패키지 추가 및 초기화

```bash
flutter pub add firebase_core
```

`main.dart` 업데이트:

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MaterialApp(home: HomeScreen()));
}
```

---

## 🔹 3. 로그인 기능 (Mock 버전)

### ✅ 로그인 UI 만들기

```dart
ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FeedScreen()),
    );
  },
  child: Text('로그인'),
);
```

### ✅ ID/PW 검사 로직 추가 (Mock용)

```dart
void _tryLogin() {
  final id = idController.text.trim();
  final pw = passwordController.text.trim();

  if (id == 'abcd' && pw == '1234') {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  } else {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('로그인 실패'),
          content: const Text('아이디와 패스워드가 일치하지 않습니다.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }
}
```

---

## 🔹 4. Firestore 연동 및 Feed 구성

### ✅ Firestore 패키지 설치

```bash
flutter pub add cloud_firestore
```

### ✅ 모델 정의: `models/feed.dart`

```dart
class Feed {
  final String title;
  final String content;
  final String imageUrl;
  final DateTime date;

  Feed({
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.date,
  });

  factory Feed.fromJson(Map<String, dynamic> json) {
    return Feed(
      title: json['title'],
      content: json['content'],
      imageUrl: json['imageUrl'],
      date: (json['date'] as Timestamp).toDate(),
    );
  }
}
```

---

### ✅ 위젯 정의: `widgets/feed_card.dart`

```dart
import 'package:flutter/material.dart';
import '../models/feed.dart';

class FeedCard extends StatelessWidget {
  final Feed feed;

  const FeedCard({super.key, required this.feed});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(feed.imageUrl),
          Text(feed.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(feed.content),
        ],
      ),
    );
  }
}
```

---

### ✅ 화면 구성: `screens/home_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/feed.dart';
import '../widgets/feed_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('피드')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('feeds').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          final docs = snapshot.data!.docs;

          final feeds = docs.map((doc) =>
            Feed.fromJson(doc.data() as Map<String, dynamic>)).toList();

          return ListView.builder(
            itemCount: feeds.length,
            itemBuilder: (context, index) {
              return FeedCard(feed: feeds[index]);
            },
          );
        },
      ),
    );
  }
}
```

---

## 📁 프로젝트 구조 예시

```text
/lib
  ├── models
  │   └── feed.dart
  ├── screens
  │   └── home_screen.dart
  ├── widgets
  │   └── feed_card.dart
  ├── firebase_options.dart
  └── main.dart
```

---

## 📚 참고 링크

- [Flutter 설치 가이드](https://docs.flutter.dev/get-started/install)
- [Firebase Console](https://console.firebase.google.com)
- [FlutterFire 공식 문서](https://firebase.flutter.dev/)

---

## 🔥 Firestore 데이터 연동 (Feed 기능)

Firestore 데이터베이스에 사용자의 감정 또는 피드 데이터를 저장하고 렌더링하는 기능을 구현함.

### 1. Firestore 패키지 추가

```bash
flutter pub add cloud_firestore
```

### 2. Firestore 임포트

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
```

### 3. 모델 생성 (`models/feed.dart`)

```dart
class Feed {
  final String title;
  final String content;
  final String imageUrl;
  final DateTime datetime;

  Feed({
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.datetime,
  });

  factory Feed.fromMap(Map<String, dynamic> data) {
    return Feed(
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      datetime: (data['datetime'] as Timestamp).toDate(),
    );
  }
}
```

> Firestore Database에 다음 필드들을 가진 문서를 수동으로 작성하거나, 앱 내에서 업로드 처리할 수 있음:
>
> - `title` (String)
> - `content` (String)
> - `imageUrl` (String)
> - `datetime` (Timestamp)

### 4. 위젯 생성 (`widgets/feed_card.dart`)

```dart
import 'package:flutter/material.dart';
import '../models/feed.dart';

class FeedCard extends StatelessWidget {
  final Feed feed;

  const FeedCard({super.key, required this.feed});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(feed.imageUrl),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(feed.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(feed.content),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(feed.datetime.toLocal().toString(), style: const TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
```

### 5. 화면 구성 (`screens/home_screen.dart`)

```dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/feed.dart';
import '../widgets/feed_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('피드')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('feeds').orderBy('datetime', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final feeds = snapshot.data!.docs.map((doc) => Feed.fromMap(doc.data() as Map<String, dynamic>)).toList();
          return ListView.builder(
            itemCount: feeds.length,
            itemBuilder: (context, index) => FeedCard(feed: feeds[index]),
          );
        },
      ),
    );
  }
}
```

