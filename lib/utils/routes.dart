import 'package:flutter/material.dart';
import 'package:video_conference_app1/Screens/Auth/login.dart';
import 'package:video_conference_app1/Screens/Auth/signup.dart';
import 'package:video_conference_app1/Screens/Auth/user_profile.dart';
import 'package:video_conference_app1/ZegoCloud/homepage.dart';
import 'package:video_conference_app1/Screens/Auth/setting_screen.dart';

class Routes {
  static Map<String, WidgetBuilder> routes = {
    '/signup': (context) => const SignupScreen(),
    '/login': (context) => const LoginScreen(),
    '/home': (context) => HomePage(),
    '/setting': (context) => const SettingScreen(),
    '/userProfile': (context) => const UserProfile(),
  };
}
