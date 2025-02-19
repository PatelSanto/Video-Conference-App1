import 'package:flutter/material.dart';
import 'package:video_conference_app1/Widgets/Side_Menu.dart';
import 'package:video_conference_app1/ZegoCloud/join_page.dart';
import 'package:video_conference_app1/ZegoCloud/new_meeting.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.purple[300],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text("Video Conference"),
        centerTitle: true,
        foregroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
            icon: Icon(Icons.menu_rounded)),
      ),
      drawer: SideMenu(scaffoldKey: _scaffoldKey),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 40, 0, 0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NewMeeting()));
              },
              label: const Text(
                "New Meeting",
                style: TextStyle(color: Colors.white),
              ),
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(350, 30),
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25))),
            ),
          ),
          const Divider(
            thickness: 1,
            height: 40,
            indent: 75,
            endIndent: 60,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => JoinPage(
                              conferenceID: '',
                            )));
              },
              icon: const Icon(Icons.margin),
              label: const Text("Join with a Code"),
              style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.indigo),
                  fixedSize: const Size(350, 30),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25))),
            ),
          ),
          Image.asset(
            'assets/images/meeting.png',
            height: 400,
            width: 400,
            fit: BoxFit.fill,
          ),
        ],
      ),
    );
  }
}
