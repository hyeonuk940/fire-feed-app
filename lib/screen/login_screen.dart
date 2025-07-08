import 'package:flutter/material.dart';
import 'package:fire_feed_app/screen/home_screen.dart'; // HomeScreen import

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController idController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

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
                  onPressed: () {
                    Navigator.of(context).pop(); // 팝업 닫기
                  },
                  child: const Text('확인'),
                ),
              ],
            );
          },
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('로그인')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: idController,
              decoration: const InputDecoration(labelText: '아이디'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: '비밀번호'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _tryLogin,
              child: const Text('로그인'),
            ),
            TextButton(
              onPressed: () {
                print('회원가입 버튼 클릭됨');
              },
              child: const Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }
}
