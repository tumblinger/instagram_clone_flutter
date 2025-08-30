import 'package:flutter/material.dart';
import 'package:instagram_clone/user_profile/user_profile_model.dart';
import 'package:instagram_clone/user_profile/user_profile_provider.dart';
import 'package:provider/provider.dart';

import '../components/app_bottom_navigation_bar.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final UserProfileModel? _userProfile = context.watch<MyAuthProvider>().userProfile;

    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
            onPressed: () => print('cancel'), child: Text('Back')
        ),
        leadingWidth: 68,
        title: Text('User Profile', style:  TextStyle(fontSize: 16),),
        actions: [
          TextButton(onPressed: () => print('done'), child: Text('Done', style: TextStyle(fontWeight: FontWeight.bold),))
        ],
      ),
      body: SafeArea(child:
      Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: Column(children: [
          if(_userProfile == null)
            Center( child: CircularProgressIndicator()),
          if(_userProfile != null)
          Column(
            children: [
              // Profile avatar:
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(_userProfile.avatar),
                      ),
                    ),
                    TextButton(
                        onPressed: ()=> print('Change profile photo'),
                        child: Text('Change profile photo', style: TextStyle(fontWeight: FontWeight.bold))
                    )
                  ],
                ),
              ),
              // Profile Info inputs:
              Column(
                children: [
                  Divider(height: 2, thickness: 1, color: Colors.black45,)
                ],
              )
            ],
          ),
        ],),
      )
      ),
        bottomNavigationBar:  AppBottomNavigationBar(currentIndex: 4)
    );
  }
}
