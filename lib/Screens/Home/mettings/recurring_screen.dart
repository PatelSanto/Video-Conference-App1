import 'package:flutter/material.dart';

class RecurringScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          RecurringCard(time: "12:00", host: "Kim", frequency: "Daily"),
          RecurringCard(time: "14:00", host: "John", frequency: "Weekly"),
        ],
      ),
    );
  }
}

class RecurringCard extends StatelessWidget {
  final String time;
  final String host;
  final String frequency;

  RecurringCard(
      {required this.time, required this.host, required this.frequency});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        leading: Icon(Icons.repeat, color: Colors.orange),
        title: Text("$time - $host"),
        subtitle: Text("Frequency: $frequency"),
        trailing: ElevatedButton(
          onPressed: () {},
          child: Text("View"),
        ),
      ),
    );
  }
}
