import 'package:flutter/material.dart';

class ClassicGamePage extends StatelessWidget {
  const ClassicGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Classic Game Page"),
      ),
      body: const Center(
        child: Text(
          "Welcome to a classic game!",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}