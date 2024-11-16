import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SideMenu extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const SideMenu({required this.scaffoldKey, super.key});

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? userName;
  String? userEmail;
  String? profilePicUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(currentUser.uid).get();
        setState(() {
          userName = userDoc['name'];
          userEmail = userDoc['email'];
          profilePicUrl = userDoc['profilePic'];
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateProfilePicture() async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        // Assume `uploadImageToStorage` is a helper function to upload images to Firebase Storage.
        String uploadedImageUrl = await uploadImageToStorage(File(image.path));
        User? currentUser = _auth.currentUser;
        if (currentUser != null) {
          await _firestore
              .collection('users')
              .doc(currentUser.uid)
              .update({'profilePic': uploadedImageUrl});
          setState(() {
            profilePicUrl = uploadedImageUrl;
          });
        }
      }
    } catch (e) {
      print('Error updating profile picture: $e');
    }
  }

  Future<String> uploadImageToStorage(File imageFile) async {
    // Logic to upload the image to Firebase Storage and get the URL
    // Replace this with your actual Firebase Storage upload logic
    return 'uploaded_image_url';
  }

  void logout() async {
    await _auth.signOut();
    Navigator.of(context)
        .pushReplacementNamed('/login'); // Replace with your login page route
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : ClipPath(
            clipper: OvalRightBorderClipper(),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Drawer(
              child: Container(
                padding: const EdgeInsets.only(left: 16.0, right: 40),
                decoration: BoxDecoration(
                  color: AppStore().appBarColor,
                ),
                width: 300,
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            GestureDetector(
                              onTap: updateProfilePicture,
                              child: Container(
                                height: 90,
                                width: 90,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 2, color: Colors.purple),
                                  image: DecorationImage(
                                    image: profilePicUrl != null
                                        ? NetworkImage(profilePicUrl!)
                                        : AssetImage(
                                                'assets/default_profile.png')
                                            as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 5,
                              right: 5,
                              child: GestureDetector(
                                onTap: updateProfilePicture,
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.purple,
                                  child: Icon(Icons.edit,
                                      size: 16, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          userName ?? "Loading...",
                          style: TextStyle(
                            color: AppStore().textPrimaryColor,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(userEmail ?? "Loading...",
                            style: TextStyle(
                                color: AppStore().textPrimaryColor,
                                fontSize: 16.0)),
                        SizedBox(height: 30),
                        ..._buildMenuItems(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

// Define all the required routes and navigate to the specified screen that have been created
  List<Widget> _buildMenuItems() {
    final List<Map<String, dynamic>> menuItems = [
      {'icon': Icons.home, 'title': "Home", 'route': '/home'},
      {'icon': Icons.person_pin, 'title': "My profile", 'route': '/profile'},
      {'icon': Icons.message, 'title': "Messages", 'route': '/messages'},
      {
        'icon': Icons.notifications,
        'title': "Notifications",
        'route': '/notifications'
      },
      {'icon': Icons.settings, 'title': "Settings", 'route': '/setting'},
      {'icon': Icons.email, 'title': "Contact us", 'route': '/contact'},
      {'icon': Icons.info_outline, 'title': "Help", 'route': '/help'},
      {'icon': Icons.logout, 'title': "Logout", 'action': logout},
    ];

    return menuItems.map((item) {
      return Column(
        children: [
          GestureDetector(
            onTap: () {
              widget.scaffoldKey.currentState!.openEndDrawer();
              if (item['route'] != null) {
                Navigator.of(context).pushNamed(item['route']);
              } else if (item['action'] != null) {
                item['action']();
              }
            },
            child: Row(
              children: [
                Icon(item['icon'], color: AppStore().iconColor),
                SizedBox(width: 10),
                Text(item['title'],
                    style: TextStyle(color: AppStore().textPrimaryColor)),
              ],
            ),
          ),
          Divider(),
          SizedBox(height: 15),
        ],
      );
    }).toList();
  }
}

class OvalRightBorderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(size.width - 50, 0);
    path.quadraticBezierTo(
        size.width, size.height / 4, size.width, size.height / 2);
    path.quadraticBezierTo(size.width, size.height - (size.height / 4),
        size.width - 40, size.height);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class AppStore {
  Color? textPrimaryColor;
  Color? iconColorPrimaryDark;
  Color? scaffoldBackground;
  Color? backgroundColor;
  Color? backgroundSecondaryColor;
  Color? appColorPrimaryLightColor;
  Color? textSecondaryColor;
  Color? appBarColor;
  Color? iconColor;
  Color? iconSecondaryColor;
  Color? cardColor;

  AppStore() {
    textPrimaryColor = Color(0xFF212121);
    iconColorPrimaryDark = Color(0xFF212121);
    scaffoldBackground = Color(0xFFEBF2F7);
    backgroundColor = Colors.black;
    backgroundSecondaryColor = Color(0xFF131d25);
    appColorPrimaryLightColor = Color(0xFFF9FAFF);
    textSecondaryColor = Color(0xFF5A5C5E);
    appBarColor = Colors.white;
    iconColor = Color(0xFF212121);
    iconSecondaryColor = Color(0xFFA8ABAD);
    cardColor = Color(0xFF191D36);
  }
}
