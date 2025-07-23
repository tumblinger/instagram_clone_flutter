import 'package:flutter/material.dart';
import '../components/app_bottom_navigation_bar.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: Center(
        child: Text("Gallery Screen"),)),
        bottomNavigationBar:  AppBottomNavigationBar(currentIndex: 1)
    );
  }
}
