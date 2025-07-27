import 'package:flutter/material.dart';
import 'package:instagram_clone/components/app_bottom_navigation_bar.dart';
import 'package:instagram_clone/components/app_follow_button.dart';
import 'package:instagram_clone/user_profile/user_profile_model.dart';
import 'package:instagram_clone/user_profile/user_profile_service.dart';

class UserPageScreen extends StatefulWidget {
  final int currentScreenIndex;
  final String userId;
  final String userName;

  const UserPageScreen({
    super.key, 
    required this.currentScreenIndex, 
    required this.userId,
    required this.userName});

  @override
  State<UserPageScreen> createState() => _UserPageScreenState();
}

class _UserPageScreenState extends State<UserPageScreen> {
  final UserProfileService userProfileService = UserProfileService();
  bool _isLoadingUserProfile = true;
  UserProfileModel? _userProfile;

   @override
  void initState() {
    _getUserProfile();
    super.initState();
  }

  Future<void> _getUserProfile() async{
    try{
      UserProfileModel? userProfile = await userProfileService.getUserProfile(widget.userId);
      if(userProfile != null){
        setState(() {
          _isLoadingUserProfile = false;
          _userProfile = userProfile;
        });
      }
    }
    catch(error){
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: ()=> Navigator.pop(context),
          child: Icon(Icons.arrow_back),
        ),
        title: Text(widget.userName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        actions: [
          AppFollowButton(color: Colors.black)
        ],
      ),
      body: SafeArea(
          child: Center(
              child: Text('User Page Screen')
          )),
      bottomNavigationBar: AppBottomNavigationBar(currentIndex: widget.currentScreenIndex),
    );
  }
}
