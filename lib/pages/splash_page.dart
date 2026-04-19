import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: Image.asset('assets/Logo.png'),
            ),
            const SizedBox(height: 20),
            SizedBox(width: 100, child: LinearProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
