import 'package:flutter/material.dart';
import 'package:instagram_clone/user_profile/user_profile_service.dart';

class AppFollowButton extends StatelessWidget {
  final Color color;
  final String currentUserId;
  final String followedUserId;
  final bool isCurrentlyFollowing;
  AppFollowButton({super.key, this.color = Colors.white, required this.currentUserId, required this.followedUserId, required this.isCurrentlyFollowing});
  final UserProfileService _userProfileService = UserProfileService();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: (){
          _userProfileService.toggleFollowStatus(
              currentUserId: currentUserId, 
              followedUserId: followedUserId, 
              isCurrentlyFollowing: isCurrentlyFollowing
          );
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color, width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          minimumSize: Size.zero
        ),
        child: Text('Follow',
          style: TextStyle(color: color, fontSize: 10)
        )
    );
  }
}
