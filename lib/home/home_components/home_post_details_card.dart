import 'package:flutter/material.dart';
import 'package:instagram_clone/create_post/post_comments/comment.bottom_sheet.dart';
import 'package:instagram_clone/create_post/posts.dart';
import 'package:intl/intl.dart';

import '../../create_post/posts_service.dart';
import '../../util/numbers.dart';

enum  ColorStyle {dark, light}

class HomePostDetailsCard extends StatelessWidget {
  final Posts post;
  final PostsService postService;
  final ColorStyle? colorStyle;
  const HomePostDetailsCard({
    super.key, 
    required this.post, 
    required this.postService, 
    this.colorStyle, 
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Row(
               children: [
                 HomePostDetailsStatistic(icon: Icons.favorite_outline, statValue: post.likes, onTap: () => postService.incrementLikes(post.id)),
                 const SizedBox(width: 12.0),
                 HomePostDetailsStatistic(icon: Icons.chat_bubble_outline, statValue: post.comments, onTap: () => {
                   showModalBottomSheet(
                       context: context,
                       isScrollControlled: true,
                       builder: (context) => CommentBottomSheet(posts: post))
                 }),
                 const SizedBox(width: 12.0),
                 HomePostDetailsStatistic(icon: Icons.send_outlined, statValue: post.shares, onTap: () => postService.incrementShares(post.id)),
               ],
             ),
             Icon(Icons.bookmark_border_outlined)
           ],
         ),

          SizedBox(height: 12.0),

          Text.rich(
              style: TextStyle(fontSize: 12.0),
              TextSpan(children: [
                TextSpan(
                  text: '${post.userName} ',
                  style: TextStyle(fontWeight: FontWeight.bold)
            ),
                TextSpan(text: post.caption)
          ])
          ),

          Text(
              DateFormat('MMM dd yyyy').format(post.createdAt),
              style: TextStyle(fontSize: 10.0, color: Colors.grey)
          )
        ],
      ),
    );
  }
}

class HomePostDetailsStatistic extends StatelessWidget {
  final IconData icon;
  final int statValue;
  final VoidCallback? onTap;

  const HomePostDetailsStatistic({super.key, required this.icon, required this.statValue, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(children: [
          Icon(icon),
          Text(shortNumber(statValue), style: TextStyle(fontSize: 10.0)),
      ],),
    );
  }
}
