import 'package:flutter/material.dart';

class LivesGamePage extends StatelessWidget {
  const LivesGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lives Game Page"),
      ),
      body: const Center(
        child: Text(
          "Welcome to a Lives game!",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}