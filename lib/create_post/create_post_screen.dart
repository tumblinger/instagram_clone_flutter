import 'package:flutter/material.dart';

import '../components/app_bottom_navigation_bar.dart';

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: Center(child: Text("Create a post Screen"),)),
        bottomNavigationBar:  AppBottomNavigationBar(currentIndex: 2)
    );
  }
}
