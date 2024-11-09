import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_conference_app1/ZegoCloud/const.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

class VideoConferencePage extends StatelessWidget {
  final String conferenceID;

  const VideoConferencePage({
    super.key,
    required this.conferenceID,
  });

  Future<Map<String, String>> getUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User is not signed in");
    }

    // Fetch user data from Firestore
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!userDoc.exists) {
      throw Exception("User document does not exist");
    }

    final data = userDoc.data()!;
    return {
      'userID': user.uid,
      'userName': data['name'] ?? 'Guest', // default to 'Guest' if no name
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: getUserInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData) {
          return Center(child: Text("User data not found"));
        }

        final userInfo = snapshot.data!;
        final userID = userInfo['userID']!;
        final userName = userInfo['userName']!;

        return SafeArea(
          child: ZegoUIKitPrebuiltVideoConference(
            appID: appId,
            appSign: appSign,
            userID: userID,
            userName: userName,
            conferenceID: conferenceID,
            config: ZegoUIKitPrebuiltVideoConferenceConfig(
              turnOnCameraWhenJoining: false,
              turnOnMicrophoneWhenJoining: false,
              topMenuBarConfig: ZegoTopMenuBarConfig(
                title: "My Conference",
                isVisible: true,
              ),
            ),
          ),
        );
      },
    );
  }
}
