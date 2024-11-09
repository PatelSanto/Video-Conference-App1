import 'package:flutter/material.dart';
import 'package:video_conference_app1/Screens/Auth/login.dart';
import 'package:video_conference_app1/Screens/Auth/signup.dart';
import 'package:video_conference_app1/Screens/Auth/user_profile.dart';
import 'package:video_conference_app1/Screens/Home/mettings/mettings.dart';
import 'package:video_conference_app1/ZegoCloud/homepage.dart';
import 'package:video_conference_app1/users/screens/addgroup/addgroup_screen.dart';
import 'package:video_conference_app1/Screens/Auth/setting_screen.dart';
import 'package:video_conference_app1/users/screens/splash/splash_screen.dart';

class Routes {
  static Map<String, WidgetBuilder> routes = {
    '/splash': (context) => const SplashScreen(),
    '/signup': (context) => const SignupScreen(),
    '/login': (context) => const LoginScreen(),
    '/home': (context) => const HomePage(),
    '/addgroup': (context) => const AddgroupScreen(),
    '/setting': (context) => const SettingScreen(),
    '/meeting': (context) => const MeetingScreen(),
    '/userProfile': (context) => const UserProfile(),
  };
}
