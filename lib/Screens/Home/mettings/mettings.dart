import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_conference_app1/Screens/Home/mettings/history_screen.dart';
import 'package:video_conference_app1/Screens/Home/mettings/personal_screen.dart';
import 'package:video_conference_app1/Screens/Home/mettings/recurring_screen.dart';
import 'package:video_conference_app1/Widgets/appbar.dart';
import 'package:video_conference_app1/constants/const_widgets.dart';

class MeetingScreen extends ConsumerStatefulWidget {
  const MeetingScreen({super.key});

  @override
  MeetingScreenState createState() => MeetingScreenState();
}

class MeetingScreenState extends ConsumerState<MeetingScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeAppBar(
        "Meetings",
        bottom: TabBar(
          splashBorderRadius: BorderRadius.circular(20),
          controller: _tabController,
          indicatorColor: secondaryColor,
          labelColor: secondaryColor,
          unselectedLabelColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.video_call), text: "Meeting"),
            Tab(icon: Icon(Icons.history), text: "History"),
            Tab(icon: Icon(Icons.repeat), text: "Recurring"),
            Tab(icon: Icon(Icons.person), text: "Personal"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const MeetingTab(),
          HistoryScreen(),
          RecurringScreen(),
          PersonalScreen(),
        ],
      ),
    );
  }
}

class MeetingTab extends StatelessWidget {
  const MeetingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        MeetingCard(
            time: "12:00",
            host: "Kim",
            description: "Project V1.0 review meeting"),
        MeetingCard(
            time: "14:00", host: "John", description: "Sprint planning"),
        MeetingCard(
            time: "16:00", host: "Alex", description: "Team retrospective"),
        MeetingCard(
            time: "18:00",
            host: "Sarah",
            description: "Marketing strategy session"),
      ],
    );
  }
}

class MeetingCard extends StatelessWidget {
  final String time;
  final String host;
  final String description;

  const MeetingCard(
      {super.key,
      required this.time,
      required this.host,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.videocam, color: Colors.blue),
        title: Text("$time - $host"),
        subtitle: Text(description),
        trailing: ElevatedButton(
          onPressed: () {
            // Add your join functionality here
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text("Join"),
        ),
      ),
    );
  }
}
