import 'package:flutter/material.dart';
import 'package:video_conference_app1/Screens/Auth/contacts.dart';
import 'package:video_conference_app1/Screens/Home/messages/messages.dart';
import 'package:video_conference_app1/Screens/Home/mettings/mettings.dart';
import 'package:video_conference_app1/constants/assets_path.dart';
import 'package:video_conference_app1/constants/const_widgets.dart';
import 'package:video_conference_app1/screens/auth/setting_screen.dart';

class Bnb extends StatefulWidget {
  const Bnb({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<Bnb> {
  var currentIndex = 0;
  final List<Widget> _screens = [
    const MeetingScreen(),
    const MessagesScreen(),
    const Contacts(),
    const SettingScreen(),
  ];

  List<String> listOfIcons = [
    mettingsIcon2,
    massagesIcon,
    contactsIcon,
    settingsIcon,
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: _screens[currentIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(20),
        height: size.width * .155,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.15),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
          borderRadius: BorderRadius.circular(50),
        ),
        child: ListView.builder(
          itemCount: 4,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: size.width * .024),
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              setState(
                () {
                  currentIndex = index;
                },
              );
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.fastLinearToSlowEaseIn,
                  margin: EdgeInsets.only(
                    bottom: index == currentIndex ? 0 : size.width * .029,
                    right: size.width * .0422,
                    left: size.width * .0422,
                  ),
                  width: size.width * .128,
                  height: index == currentIndex ? size.width * .014 : 0,
                  decoration: const BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(10),
                    ),
                  ),
                ),
                Image(
                  color: index == currentIndex ? primaryColor : Colors.black38,
                  image: AssetImage(
                    listOfIcons[index],
                  ),
                  width: size.width * .076,
                ),
                SizedBox(height: size.width * .03),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
