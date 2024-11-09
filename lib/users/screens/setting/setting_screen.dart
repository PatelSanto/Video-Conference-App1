import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Setting Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey.shade300,
                child: const Icon(Icons.key),
              ),
              title: const Text(
                "Account",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              subtitle: const Text(
                "Privacy, security, change number",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey.shade300,
                child: const Icon(Icons.chat),
              ),
              title: const Text(
                "Chat",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              subtitle: const Text(
                "Chat history,theme,wallpapers",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey.shade300,
                child: const Icon(Icons.notifications),
              ),
              title: const Text(
                "Notifications",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              subtitle: const Text(
                "Messages, group and others",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey.shade300,
                child: const Icon(Icons.help),
              ),
              title: const Text(
                "Help",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              subtitle: const Text(
                "Help center,contact us, privacy policy",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey.shade300,
                child: const Icon(Icons.group),
              ),
              title: const Text(
                "Invite a friend",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
