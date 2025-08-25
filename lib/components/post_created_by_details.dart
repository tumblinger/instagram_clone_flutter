import 'package:flutter/material.dart';
import 'package:instagram_clone/create_post/posts.dart';

import '../user_profile/user_page_screen.dart';

class PostCreatedByDetails extends StatelessWidget {
  final Posts post;
  final int currentScreenIndex;

  const PostCreatedByDetails({super.key, required this.post, required this.currentScreenIndex});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(
          builder: (context) => UserPageScreen(
              currentScreenIndex: currentScreenIndex,
              userId: post.userId,
              userName: post.userName)
      )),
      child: Row(
        children: [
          SizedBox(
            width: 28.0,
            child: CircleAvatar(
                backgroundImage: NetworkImage(post.avatar)),
          ),

          SizedBox(width: 12.0),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(post.userName, style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: Colors.white)),
              const Text('Suggested for you', style: TextStyle(fontSize: 10.0, color: Colors.white))
            ],)
        ],),
    );
  }
}
