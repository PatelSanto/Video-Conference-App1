import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          HistoryCard(
              time: "10:00",
              date: "Feb 26",
              host: "Kim",
              topic: "Project V1 Review"),
          HistoryCard(
              time: "12:00",
              date: "Feb 25",
              host: "Alex",
              topic: "Team Retrospective"),
        ],
      ),
    );
  }
}

class HistoryCard extends StatelessWidget {
  final String time;
  final String date;
  final String host;
  final String topic;

  HistoryCard(
      {required this.time,
      required this.date,
      required this.host,
      required this.topic});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        leading: Icon(Icons.history, color: Colors.grey),
        title: Text("$time - $host"),
        subtitle: Text("$date - $topic"),
        trailing: ElevatedButton(
          onPressed: () {},
          child: Text("View"),
        ),
      ),
    );
  }
}
