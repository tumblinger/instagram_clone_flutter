import 'package:flutter/material.dart';

import '../components/app_bottom_navigation_bar.dart';

class ReelsScreen extends StatelessWidget {
  const ReelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: Center(child: Text("Reels Screen"),)),
        bottomNavigationBar:  AppBottomNavigationBar(currentIndex: 3)
    );
  }
}
