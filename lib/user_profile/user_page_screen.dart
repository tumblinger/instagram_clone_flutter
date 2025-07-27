import 'package:flutter/material.dart';
import 'package:instagram_clone/components/app_bottom_navigation_bar.dart';
import 'package:instagram_clone/user_profile/user_profile_model.dart';

class UserPageScreen extends StatelessWidget {
  final int currentScreenIndex;
  final UserProfileModel userProfile;
  
  const UserPageScreen({
    super.key, 
    required this.currentScreenIndex, 
    required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: ()=> Navigator.pop(context),
          child: Icon(Icons.arrow_back),
        ),
        title: Text(userProfile.userName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        actions: [
          OutlinedButton(
              onPressed: (){}, 
              child: Text('hi'))
        ],
      ),
      body: SafeArea(
          child: Center(
              child: Text('User Page Screen')
          )),
      bottomNavigationBar: AppBottomNavigationBar(currentIndex: currentScreenIndex),
    );
  }
}

