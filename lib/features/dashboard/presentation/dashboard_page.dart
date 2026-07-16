import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lely Robot Dashboard'),
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: const Center(child: Text('Welcome to your Dashboard!')),
    );
  }
}
