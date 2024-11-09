import 'package:flutter/material.dart';
import 'package:video_conference_app1/Widgets/appbar.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeAppBar("Messages"),
      body: const Center(
        child: Text("Messages Screen"),
      ),
    );
  }
}
