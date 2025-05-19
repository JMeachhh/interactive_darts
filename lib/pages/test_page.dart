import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test Game Page"),
      ),
      body: const Center(
        child: Text(
          "Welcome to the test game!",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
