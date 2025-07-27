import 'package:flutter/material.dart';
import 'package:instagram_clone/components/app_bottom_navigation_bar.dart';

class UserPageScreen extends StatelessWidget {
  final int currentScreenIndex;
  const UserPageScreen({super.key, required this.currentScreenIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
              child: Text('User Page Screen')
          )),
      bottomNavigationBar: AppBottomNavigationBar(currentIndex: currentScreenIndex),
    );
  }
}
