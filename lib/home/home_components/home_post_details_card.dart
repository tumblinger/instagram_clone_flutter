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
  final ColorStyle colorStyle;

   const HomePostDetailsCard({
    super.key,
    required this.post,
    required this.postService,
    this.colorStyle = ColorStyle.dark,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = ColorStyle == ColorStyle.dark ? Colors.black : Colors.white;
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
                 HomePostDetailsStatistic(icon: Icons.favorite_outline, statValue: post.likes, color: color, onTap: () => postService.incrementLikes(post.id)),
                 const SizedBox(width: 12.0),
                 HomePostDetailsStatistic(icon: Icons.chat_bubble_outline, statValue: post.comments, color: color, onTap: () => {
                   showModalBottomSheet(
                       context: context,
                       isScrollControlled: true,
                       builder: (context) => CommentBottomSheet(posts: post))
                 }),
                 const SizedBox(width: 12.0),
                 HomePostDetailsStatistic(icon: Icons.send_outlined, statValue: post.shares, color: color, onTap: () => postService.incrementShares(post.id)),
               ],
             ),
             Icon(Icons.bookmark_border_outlined, color: color)
           ],
         ),

          SizedBox(height: 12.0),

          Text.rich(
              style: TextStyle(fontSize: 12.0),
              TextSpan(children: [
                TextSpan(
                  text: '${post.userName} ',
                  style: TextStyle(fontWeight: FontWeight.bold, color: color)
            ),
                TextSpan(text: post.caption, style: TextStyle(color: color))
          ])
          ),

          Text(
              DateFormat('MMM dd yyyy').format(post.createdAt),
              style: TextStyle(fontSize: 10.0, color: colorStyle == ColorStyle.dark ? Colors.grey : Colors.white70)
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
  final Color color;

  const HomePostDetailsStatistic({super.key, required this.icon, required this.statValue, this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(children: [
          Icon(icon, color: color),
          Text(shortNumber(statValue), style: TextStyle(fontSize: 10.0, color: color)),
      ],),
    );
  }
}
