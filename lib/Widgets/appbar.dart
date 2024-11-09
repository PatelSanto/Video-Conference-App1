import 'package:flutter/material.dart';
import 'package:video_conference_app1/constants/const_widgets.dart';

PreferredSizeWidget homeAppBar(
  String title, {
  Widget? leadingWidget,
  List<Widget>? listOfAction,
  PreferredSizeWidget? bottom,
}) {
  return AppBar(
    backgroundColor: primaryColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    title: Text(title),
    foregroundColor: Colors.white,
    centerTitle: true,
    leading: leadingWidget,
    actions: listOfAction,
    bottom: bottom,
  );
}
