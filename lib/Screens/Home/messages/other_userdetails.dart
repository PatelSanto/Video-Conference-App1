import 'package:flutter/material.dart';

class OtherUserdetails extends StatelessWidget {
  const OtherUserdetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Abrar',
                        style: TextStyle(fontSize: 30),
                      ),
                      Text(
                        'abrar@gmail.com',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person),
                  ),
                ],
              ),
              const Divider(height: 80),
              rowTile(
                title: 'Chat',
                icon: Icons.chat_bubble,
                onTap: () {},
              ),
              rowTile(
                title: 'Video Call',
                icon: Icons.video_call,
                onTap: () {},
              ),
              rowTile(
                title: 'Audio Call',
                icon: Icons.mic,
                onTap: () {},
              ),
              rowTile(
                title: 'Screen Sharing',
                icon: Icons.screen_share_outlined,
                onTap: () {},
              ),
              const SizedBox(height: 350),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Add to Contact',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget rowTile({
    required Function() onTap,
    required String title,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18),
            ),
            Icon(
              icon,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}