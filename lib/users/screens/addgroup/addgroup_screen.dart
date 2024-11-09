import 'package:flutter/material.dart';

class AddgroupScreen extends StatefulWidget {
  const AddgroupScreen({super.key});

  @override
  State<AddgroupScreen> createState() => _AddgroupScreenState();
}

class _AddgroupScreenState extends State<AddgroupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Create Group"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Group Description",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const Text(
              "Make Group  for Team Work",
              style: TextStyle(
                fontSize: 40,
              ),
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Group Work"),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Team relationship"),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Group Admin",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Row(
              children: [
                CircleAvatar(
                  radius: 30,
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Group Name",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      "Group Name",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Invited Members",
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 40,
                ),
                CircleAvatar(
                  radius: 40,
                ),
                CircleAvatar(
                  radius: 40,
                ),
                CircleAvatar(
                  radius: 40,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Row(
              children: [
                CircleAvatar(
                  radius: 40,
                ),
                SizedBox(
                  width: 20,
                ),
                CircleAvatar(
                  radius: 40,
                ),
                SizedBox(
                  width: 20,
                ),
                CircleAvatar(
                  radius: 40,
                  child: Icon(
                    Icons.add,
                    size: 40,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Container(
              height: 50,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text("Create Group"),
            ),
          ],
        ),
      ),
    );
  }
}
