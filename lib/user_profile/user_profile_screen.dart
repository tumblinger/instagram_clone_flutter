import 'package:flutter/material.dart';

import '../components/app_bottom_navigation_bar.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: Center(child: Text("User Profile Screen"),)),
        bottomNavigationBar:  AppBottomNavigationBar(currentIndex: 4)
    );
  }
}
