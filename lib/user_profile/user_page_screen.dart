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
  bool _isLoadingUserProfile = true; //FLAG: while user's profile is loading...
  UserProfileModel? _userProfile; // user's profile is loaded

  @override
  void initState() { //call it only once when the screen is loaded
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
      rethrow; //throw the error one more time for debugging
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
          Padding(padding: EdgeInsets.only(right: 16),
             child: AppFollowButton(color: Colors.black)),

        ],
      ),
      body: SafeArea(
          child: _isLoadingUserProfile ? CircularProgressIndicator(strokeWidth: 2) :
          Column(
             children: [
               if(_userProfile != null)
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                   SizedBox(
                     width: 60,
                     height: 60,
                     child: CircleAvatar(backgroundImage: NetworkImage(_userProfile!.avatar),),
                   ),
                   Expanded(
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         UserStatistics(value: _userProfile?.totalPosts ?? 0, label: 'Posts'),
                         UserStatistics(value: _userProfile?.totalFollowers ?? 0, label: 'Followers'),
                         UserStatistics(value: _userProfile?.totalFollowing ?? 0, label: 'Following'),
                       ],
                     ),
                   )

                 ],),
               )
             ],
          )),
      bottomNavigationBar: AppBottomNavigationBar(currentIndex: widget.currentScreenIndex),
    );
  }
}

class UserStatistics extends StatelessWidget {
  final int value;
  final String label;
  const UserStatistics({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
            '$value',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 10),)
      ],
    );
  }
}
