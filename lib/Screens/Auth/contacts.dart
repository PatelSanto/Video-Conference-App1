import 'package:flutter/material.dart';
import 'package:video_conference_app1/Widgets/appbar.dart';

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeAppBar("Contacts"),
      body: const Center(
        child: Text("Contacts Screen"),
      ),
    );
  }
}
