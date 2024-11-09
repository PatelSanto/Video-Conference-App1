import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:video_conference_app1/ZegoCloud/conference_screen.dart';
import 'package:share_plus/share_plus.dart';

class NewMeeting extends StatefulWidget {
  const NewMeeting({super.key});

  @override
  State<NewMeeting> createState() => _NewMeetingState();
}

class _NewMeetingState extends State<NewMeeting> {
  late String _conferenceID;

  @override
  void initState() {
    super.initState();
    // Generate a unique conference ID
    var uuid = Uuid();
    _conferenceID = uuid.v4().substring(0, 8); // Generate 8-character ID
  }

  // Method to share the conference ID using share_plus
  Future<void> _shareConferenceId() async {
    Share.share('Join My Video Conference with code: $_conferenceID');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: InkWell(
                onTap: Navigator.of(context).pop,
                child: const Icon(
                  Icons.arrow_back_ios_new_sharp,
                  size: 25,
                ),
              ),
            ),
            const SizedBox(height: 60),
            Image.asset(
              'assets/images/newmeeting.png',
              fit: BoxFit.cover,
              height: 150,
            ),
            const SizedBox(height: 20),
            const Text(
              "Your Meeting is Ready",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
              child: Card(
                color: Colors.grey[300],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                child: ListTile(
                  leading: const Icon(Icons.link),
                  title: SelectableText(
                    _conferenceID,
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  trailing: InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: _conferenceID));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Conference ID copied!")),
                      );
                    },
                    child: const Icon(Icons.copy),
                  ),
                ),
              ),
            ),
            const Divider(
              thickness: 1,
              height: 40,
              indent: 20,
              endIndent: 20,
            ),
            ElevatedButton.icon(
              onPressed: _shareConferenceId,
              label: const Text(
                "Share Invite",
                style: TextStyle(color: Colors.white),
              ),
              icon: const Icon(Icons.share, color: Colors.white),
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(350, 30),
                backgroundColor: Colors.indigo,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoConferencePage(
                      conferenceID: _conferenceID,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.video_call),
              label: const Text("Start Meeting"),
              style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.indigo),
                  fixedSize: const Size(350, 30),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25))),
            ),
          ],
        ),
      ),
    );
  }
}
