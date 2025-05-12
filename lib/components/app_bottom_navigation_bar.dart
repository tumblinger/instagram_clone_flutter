import 'package:flutter/material.dart';

class AppBottomNavigationBar extends StatefulWidget {
  const AppBottomNavigationBar({super.key});

  @override
  State<AppBottomNavigationBar> createState() => _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState extends State<AppBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.pinkAccent,
        items: [
      BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
      BottomNavigationBarItem(icon: Icon(Icons.search_outlined), label: ''),
      BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined), label: ''),
      BottomNavigationBarItem(icon: Icon(Icons.video_collection_outlined), label: ''),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
    ]);
  }
}
