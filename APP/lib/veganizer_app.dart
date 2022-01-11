import 'package:flutter/material.dart';
import 'package:veganizer/pages/camera_page.dart';
import 'package:veganizer/navbar.dart';

class RootWidget extends StatefulWidget {
  const RootWidget({Key? key}) : super(key: key);

  @override
  VeganizerApp createState() => VeganizerApp();
}

class VeganizerApp extends State<RootWidget> {
  static int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: NavBar(streamController2.stream));
  }
}
