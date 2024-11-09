import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/addgroup');
              },
              child: const Text("add-group"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/setting');
              },
              child: const Text("Setting Page"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/meeting');
              },
              child: const Text("Meeting Page"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/addgroup');
              },
              child: const Text("add-group"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text("Add Group"),
      ),
    );
  }
}
