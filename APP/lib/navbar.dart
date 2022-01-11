import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:veganizer/pages/camera_page.dart';
import 'package:veganizer/pages/recipe_page.dart';
import 'package:veganizer/pages/stores_page.dart';
import 'dart:async';

class NavBar extends StatefulWidget {
  NavBar(this.stream);
  final Stream<int> stream;
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  static int currentIndex = 0;

  void initState() {
    super.initState();
    widget.stream.listen((index) {
      mySetState(index);
    });
  }

  void mySetState(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: [
          CameraPage(),
          WebViewContainer(streamController1.stream),
          MapLauncherDemo()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        currentIndex: currentIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.green[200],
        backgroundColor: Colors.grey[600],
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt), label: "Veganize"),
          BottomNavigationBarItem(icon: Icon(Icons.public), label: "Recipe"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Stores")
        ],
      ),
    );
  }
}
