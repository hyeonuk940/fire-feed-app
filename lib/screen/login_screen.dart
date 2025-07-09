import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fire_feed_app/screen/home_screen.dart'; // HomeScreen import
import 'package:fire_feed_app/screen/signup_screen.dart'; // SignupScreen import

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController idController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    void _tryLogin() async {
      final id = idController.text.trim();
      final pw = passwordController.text.trim();

      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: id, password: pw);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } on FirebaseAuthException catch (e) {
        String message = '로그인에 실패했습니다.';
        if (e.code == 'user-not-found') {
          message = '해당 이메일을 가진 사용자가 없습니다.';
        } else if (e.code == 'wrong-password') {
          message = '비밀번호가 틀렸습니다.';
        }

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('로그인 실패'),
              content: Text(message),
              actions: [
                TextButton(onPressed: () => Navigator.of(context).pop(),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignupScreen()),
                );
              },
              child: const Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }
}
